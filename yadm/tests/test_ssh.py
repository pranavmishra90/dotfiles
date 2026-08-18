from __future__ import annotations

import os
import subprocess
from pathlib import Path

import pytest


TEST_DIR = Path(__file__).resolve().parent
TEST_SHELL = TEST_DIR / "test-ssh.sh"
REPO_ROOT = TEST_DIR.parent.parent


@pytest.mark.parametrize(
    ("shell_name", "shell_bin"),
    [
        pytest.param("sh", "sh", id="sh"),
        pytest.param("bash", "bash", id="bash"),
        pytest.param("zsh", "zsh", id="zsh"),
    ],
)
def test_start_ssh_agent_matrix(shell_name: str, shell_bin: str) -> None:
    env = os.environ.copy()
    env.update(
        {
            "YADM_TEST": "1",
            "YADM_ROOT": str(REPO_ROOT),
            "SHELL_NAME": shell_name,
            "SHELL_BIN": shell_bin,
        }
    )

    result = subprocess.run(
        ["sh", str(TEST_SHELL)],
        cwd=REPO_ROOT,
        env=env,
        text=True,
        capture_output=True,
    )

    assert result.returncode == 0, result.stderr or result.stdout