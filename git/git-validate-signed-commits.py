#!/usr/bin/env -S uv run
# /// script
# requires-python = ">=3.10"
# dependencies = []
# ///

"""Validate SSH signing keys and certificates embedded in Git commits."""

from __future__ import annotations

import argparse
import base64
import binascii
import hashlib
import json
import struct
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path


SSH_BEGIN = b"-----BEGIN SSH SIGNATURE-----"
SSH_END = b"-----END SSH SIGNATURE-----"

CERTIFICATE_KEY_SUFFIX = "-cert-v01@openssh.com"

VALID_PRINCIPAL_KINDS = {
    "person",
    "bot",
    "machine",
    "service",
}


@dataclass(frozen=True)
class Principal:
    """An SSH certificate principal."""

    raw: str
    kind: str | None
    name: str | None

    @classmethod
    def parse(cls, value: str) -> Principal:
        """Parse a principal such as person/pranav."""
        kind, separator, name = value.partition("/")

        if not separator:
            return cls(
                raw=value,
                kind=None,
                name=None,
            )

        return cls(
            raw=value,
            kind=kind,
            name=name,
        )

    @property
    def valid(self) -> bool:
        """Whether the principal uses a recognized namespace."""
        return (
            self.kind in VALID_PRINCIPAL_KINDS
            and bool(self.name)
        )


@dataclass(frozen=True)
class AllowedSigner:
    """An @cert-authority entry from Git's allowed-signers file."""

    principals: str
    key_type: str
    key: bytes
    line: str

    @property
    def fingerprint(self) -> str:
        """Return the SHA256 fingerprint of the CA public key."""
        return ssh_fingerprint(self.key)


@dataclass(frozen=True)
class Inspection:
    """Normalized representation of a commit's SSH signing identity."""

    commit: str
    key_id: str
    principals: tuple[Principal, ...]
    public: str
    ca: str
    trust: str
    ssh_public_cert: str | None = None

    @property
    def principal(self) -> str:
        """Return recognized principals for human-readable output."""
        principals = [
            principal.raw
            for principal in self.principals
            if principal.valid
        ]

        return ", ".join(principals) or "-"

    @property
    def principal_types(self) -> tuple[str, ...]:
        """Return unique recognized principal types."""
        return tuple(
            dict.fromkeys(
                principal.kind
                for principal in self.principals
                if principal.valid and principal.kind is not None
            )
        )

    @property
    def valid_principals(self) -> bool:
        """Whether the certificate has at least one recognized principal."""
        return bool(self.principals) and all(
            principal.valid
            for principal in self.principals
        )

def run(
    command: list[str],
    *,
    input: str | None = None,
) -> str:
    """Run a command and return stdout."""
    result = subprocess.run(
        command,
        input=input,
        text=True,
        capture_output=True,
    )

    if result.returncode:
        message = result.stderr.strip() or "command failed"
        raise RuntimeError(
            f"{' '.join(command)}: {message}"
        )

    return result.stdout


def git(*args: str) -> str:
    """Run Git and return stdout."""
    return run(["git", *args])


def resolve_commit(commit: str) -> str:
    """Resolve a Git commit-ish to its full SHA."""
    return git(
        "rev-parse",
        "--verify",
        f"{commit}^{{commit}}",
    ).strip()


def extract_public_key(commit: str) -> bytes:
    """Extract the SSH public-key blob from a Git SSH signature."""
    data = git("cat-file", "commit", commit).encode()

    signature_lines: list[bytes] = []
    in_signature = False

    for line in data.splitlines():
        if line.startswith(b"gpgsig "):
            value = line[len(b"gpgsig ") :]

            if value != SSH_BEGIN:
                raise RuntimeError(
                    "gpgsig is not an SSH signature"
                )

            in_signature = True
            continue

        if not in_signature:
            continue

        if not line.startswith(b" "):
            break

        value = line[1:]

        if value == SSH_END:
            break

        signature_lines.append(value)

    if not signature_lines:
        raise RuntimeError("no SSH signature")

    try:
        signature = base64.b64decode(
            b"".join(signature_lines),
            validate=True,
        )
    except binascii.Error as exc:
        raise ValueError(
            "invalid SSH signature encoding"
        ) from exc

    if signature[:6] != b"SSHSIG":
        raise ValueError(
            "signature is not an SSHSIG signature"
        )

    offset = 6

    # uint32 version
    if len(signature) < offset + 4:
        raise ValueError(
            "truncated SSHSIG signature"
        )

    version = struct.unpack(
        ">I",
        signature[offset : offset + 4],
    )[0]

    if version != 1:
        raise ValueError(
            f"unsupported SSHSIG version: {version}"
        )

    offset += 4

    # SSH string containing the public key.
    if len(signature) < offset + 4:
        raise ValueError(
            "truncated SSHSIG signature"
        )

    length = struct.unpack(
        ">I",
        signature[offset : offset + 4],
    )[0]

    offset += 4
    end = offset + length

    if end > len(signature):
        raise ValueError(
            "truncated SSH public-key blob"
        )

    return signature[offset:end]


def ssh_key_type(public_key: bytes) -> str:
    """Extract the key type from an SSH public-key blob."""
    if len(public_key) < 4:
        raise ValueError(
            "invalid SSH public-key blob"
        )

    length = struct.unpack(
        ">I",
        public_key[:4],
    )[0]

    end = 4 + length

    if end > len(public_key):
        raise ValueError(
            "invalid SSH public-key blob"
        )

    try:
        return public_key[4:end].decode("ascii")
    except UnicodeDecodeError as exc:
        raise ValueError(
            "invalid SSH key type"
        ) from exc


def ssh_public_key_line(public_key: bytes) -> str:
    """Convert an SSH public-key blob to authorized_keys format."""
    key_type = ssh_key_type(public_key)
    encoded = base64.b64encode(
        public_key
    ).decode("ascii")

    return f"{key_type} {encoded}"


def ssh_fingerprint(public_key: bytes) -> str:
    """Return an OpenSSH-style SHA256 fingerprint."""
    digest = hashlib.sha256(public_key).digest()

    encoded = base64.b64encode(
        digest
    ).decode("ascii").rstrip("=")

    return f"SHA256:{encoded}"


def fingerprint_suffix(
    fingerprint: str | None,
) -> str:
    """Return the final six characters of a fingerprint."""
    if not fingerprint:
        return "-"

    return fingerprint[-6:]


def allowed_signers_file() -> Path:
    """Return Git's configured SSH allowed-signers file."""
    path = git(
        "config",
        "--get",
        "gpg.ssh.allowedSignersFile",
    ).strip()

    if not path:
        raise RuntimeError(
            "gpg.ssh.allowedSignersFile is not configured"
        )

    return Path(path).expanduser()


def load_allowed_signers() -> list[AllowedSigner]:
    """Load @cert-authority entries from Git's allowed-signers file."""
    path = allowed_signers_file()

    try:
        lines = path.read_text(
            encoding="utf-8"
        ).splitlines()
    except OSError as exc:
        raise RuntimeError(
            f"could not read allowed-signers file "
            f"{path}: {exc}"
        ) from exc

    signers: list[AllowedSigner] = []

    for line in lines:
        line = line.strip()

        if not line or line.startswith("#"):
            continue

        parts = line.split()

        if len(parts) < 4:
            continue

        if parts[0] != "@cert-authority":
            continue

        principals = parts[1]
        key_type = parts[2]
        encoded_key = parts[3]

        try:
            key = base64.b64decode(
                encoded_key,
                validate=True,
            )
        except binascii.Error:
            continue

        signers.append(
            AllowedSigner(
                principals=principals,
                key_type=key_type,
                key=key,
                line=line,
            )
        )

    return signers


def format_trust(line: str) -> str:
    """Remove CA public-key material from an allowed-signers entry."""
    parts = line.split()

    if len(parts) >= 4:
        return " ".join(parts[:3])

    return line


def find_trust(
    ca_fingerprint: str,
    allowed_signers: list[AllowedSigner],
) -> str:
    """Find the allowed-signers entry matching a CA fingerprint."""
    for signer in allowed_signers:
        if signer.fingerprint == ca_fingerprint:
            return format_trust(signer.line)

    return "-"


def inspect_with_step(public_key: bytes) -> dict:
    """Inspect an SSH public key/certificate with step."""
    key = ssh_public_key_line(public_key)

    result = subprocess.run(
        [
            "step",
            "ssh",
            "inspect",
            "/dev/stdin",
            "--format",
            "json",
        ],
        input=key + "\n",
        text=True,
        capture_output=True,
    )

    if result.returncode:
        raise RuntimeError(
            result.stderr.strip()
            or "step ssh inspect failed"
        )

    try:
        return json.loads(result.stdout)
    except json.JSONDecodeError as exc:
        raise RuntimeError(
            "step ssh inspect returned invalid JSON"
        ) from exc


def parse_principals(
    values: list[str] | None,
) -> tuple[Principal, ...]:
    """Parse SSH certificate principals."""
    if not values:
        return ()

    return tuple(
        Principal.parse(value)
        for value in values
    )

def inspect_signed_commit(
    commit: str,
    allowed_signers: list[AllowedSigner],
) -> Inspection:
    """Inspect a signed commit, certificate or bare public key."""
    public_key = extract_public_key(commit)

    public_fingerprint = ssh_fingerprint(public_key)
    public = fingerprint_suffix(public_fingerprint)

    key_type = ssh_key_type(public_key)
    ssh_public_cert = ssh_public_key_line(public_key)

    # A non-certificate SSH key is a valid bare SSH signature.
    if not key_type.endswith(CERTIFICATE_KEY_SUFFIX):
        return Inspection(
            commit=commit,
            key_id="bare",
            principals=(),
            public=public,
            ca="-",
            trust="bare key",
            ssh_public_cert=ssh_public_cert,
        )

    info = inspect_with_step(public_key)

    ca_fingerprint = info.get("SigningKeyFingerprint")

    if ca_fingerprint:
        ca = fingerprint_suffix(ca_fingerprint)
        trust = find_trust(
            ca_fingerprint,
            allowed_signers,
        )
    else:
        ca = "-"
        trust = "-"

    principals = parse_principals(
        info.get("Principals")
    )

    return Inspection(
        commit=commit,
        key_id=info.get("KeyID", "-"),
        principals=principals,
        public=fingerprint_suffix(
            info.get("KeyFingerprint")
            or public_fingerprint
        ),
        ca=ca,
        trust=trust,
        ssh_public_cert=ssh_public_cert,
    )

def inspect_commit(
    commit: str,
    allowed_signers: list[AllowedSigner],
) -> Inspection | None:
    """Inspect a commit, returning None if unsigned."""
    try:
        return inspect_signed_commit(
            commit,
            allowed_signers,
        )
    except RuntimeError as exc:
        if str(exc) == "no SSH signature":
            return None

        raise


def find_branch_point() -> str:
    """Find the branch point of HEAD.

    Prefer the configured upstream branch. Otherwise try main/master.
    """
    try:
        upstream = git(
            "rev-parse",
            "--abbrev-ref",
            "--symbolic-full-name",
            "@{upstream}",
        ).strip()
    except RuntimeError:
        upstream = ""

    candidates = (
        [upstream]
        if upstream
        else []
    )

    candidates.extend(
        branch
        for branch in ("main", "master")
        if branch not in candidates
    )

    for branch in candidates:
        try:
            merge_base = git(
                "merge-base",
                "HEAD",
                branch,
            ).strip()
        except RuntimeError:
            continue

        if merge_base:
            return merge_base

    raise RuntimeError(
        "could not determine branch point; "
        "set an upstream branch or have a local "
        "main/master branch"
    )


def branch_commits() -> list[str]:
    """Return commits after branch point, oldest first."""
    return list(
        reversed(
            git(
                "rev-list",
                "--first-parent",
                "HEAD",
                f"^{find_branch_point()}",
            ).splitlines()
        )
    )


def unsigned_inspection(
    commit: str,
) -> Inspection:
    """Create an inspection for an unsigned commit."""
    return Inspection(
        commit=commit,
        key_id="Unsigned",
        principals=(),
        ssh_public_key=None,
        public="-",
        ca="-",
        trust="-",
    )


def inspection_to_json(
    inspection: Inspection,
) -> dict:
    """Convert an inspection to JSON-compatible data."""
    return {
        "commit": inspection.commit,
        "key_id": inspection.key_id,
        "principals": [
            {
                "kind": principal.kind,
                "name": principal.name,
                "valid": principal.valid,
            }
            for principal in inspection.principals
        ],
        "public": inspection.public,
        "ca": inspection.ca,
        "trust": inspection.trust,
        "ssh_key": inspection.ssh_public_cert,
    }

def branch_to_json(
    branch_point: str,
    rows: list[Inspection],
    failures: int,
) -> dict:
    """Build the unified JSON representation."""
    return {
        "branch_point": branch_point,
        "inspected": len(rows),
        "failures": failures,
        "commits": {
            row.commit: inspection_to_json(row)
            for row in rows
        },
    }


def print_table(
    rows: list[Inspection],
) -> None:
    """Render inspections as a table."""
    headers = (
        "Commit",
        "Key ID",
        "Principal",
        "Public",
        "CA",
        "Trust",
    )

    values = [
        (
            row.commit[:12],
            row.key_id,
            row.principal,
            row.public,
            row.ca,
            row.trust,
        )
        for row in rows
    ]

    if not values:
        print("No commits to inspect.")
        return

    widths = [
        max(
            len(header),
            *(len(row[index]) for row in values),
        )
        for index, header in enumerate(headers)
    ]

    def format_row(
        row: tuple[str, ...],
    ) -> str:
        return "  ".join(
            value.ljust(width)
            for value, width in zip(
                row,
                widths,
            )
        ).rstrip()

    print(format_row(headers))

    print(
        format_row(
            tuple(
                "-" * width
                for width in widths
            )
        )
    )

    for row in values:
        print(format_row(row))


def inspect_branch(
    *,
    json_output: bool,
) -> int:
    """Inspect all commits on the current branch."""
    branch_point = find_branch_point()
    commits = branch_commits()
    allowed_signers = load_allowed_signers()

    rows: list[Inspection] = []
    failures = 0

    for commit in commits:
        try:
            inspection = inspect_commit(
                commit,
                allowed_signers,
            )

            if inspection is None:
                rows.append(
                    unsigned_inspection(commit)
                )
            else:
                rows.append(inspection)

        except (
            RuntimeError,
            ValueError,
            json.JSONDecodeError,
        ) as exc:
            print(
                f"{commit[:12]}  ERROR: {exc}",
                file=sys.stderr,
            )
            failures += 1

    if json_output:
        print(
            json.dumps(
                branch_to_json(
                    branch_point,
                    rows,
                    failures,
                ),
                indent=2,
            )
        )
    else:
        print_table(rows)

        print()
        print(
            f"Branch point: {branch_point}"
        )
        print(
            f"Inspected:    {len(commits)}"
        )
        print(
            f"Failures:     {failures}"
        )

    return 1 if failures else 0


def build_argument_parser() -> argparse.ArgumentParser:
    """Build the command-line parser."""
    parser = argparse.ArgumentParser(
        description=(
            "Validate SSH signing keys and certificates "
            "embedded in Git commits."
        ),
    )

    parser.add_argument(
        "commit",
        nargs="?",
        default="HEAD",
        help=(
            "Git commit-ish to inspect, or 'branch' to "
            "inspect all commits from HEAD to the branch point."
        ),
    )

    parser.add_argument(
        "--json",
        action="store_true",
        help="Output one unified JSON document.",
    )

    return parser


def main() -> int:
    """CLI entry point."""
    args = build_argument_parser().parse_args()

    try:
        if args.commit == "branch":
            return inspect_branch(
                json_output=args.json,
            )

        commit = resolve_commit(args.commit)
        allowed_signers = load_allowed_signers()

        inspection = inspect_commit(
            commit,
            allowed_signers,
        )

        if inspection is None:
            if args.json:
                print(
                    json.dumps(
                        {
                            commit: {
                                "commit": commit,
                                "key_id": "Unsigned",
                                "principals": [],
                                "ssh_public_key": None,
                                "public": "-",
                                "ca": "-",
                                "trust": "-",
                            }
                        },
                        indent=2,
                    )
                )
            else:
                print("Unsigned")

            return 0

        if args.json:
            print(
                json.dumps(
                    {
                        commit: inspection_to_json(
                            inspection
                        )
                    },
                    indent=2,
                )
            )
        else:
            print_table([inspection])

        return 0

    except (
        RuntimeError,
        ValueError,
        json.JSONDecodeError,
    ) as exc:
        print(
            f"ERROR: {exc}",
            file=sys.stderr,
        )
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
