#!/usr/bin/env bash

set -euo pipefail

# Find all files and files with '##' indicating a yadm dynamic symlink
all_files=()
while IFS= read -r file; do
	[[ -n "$file" ]] && all_files+=("$file")
done < <(git ls-files)

files_with_hashes=()
while IFS= read -r file; do
	[[ -n "$file" ]] && files_with_hashes+=("$file")
done < <(git ls-files | grep "##")

printf '\nfiles_with_hashes (%d):\n' "${#files_with_hashes[@]}"
if ((${#files_with_hashes[@]})); then
	printf '  %s\n' "${files_with_hashes[@]}"
fi

all_symlinks=()
for file in "${all_files[@]}"; do
    [[ -L "$file" ]] && all_symlinks+=("$file")
done

printf '\nall_symlinks (%d):\n' "${#all_symlinks[@]}"
if ((${#all_symlinks[@]})); then
	printf '  %s\n' "${all_symlinks[@]}"
fi


# Find the files which are symlink start points (symlink sources)
symlink_sources=()
for file in "${all_files[@]}"; do
	if [[ -L "$file" ]]; then
		symlink_sources+=("$file")
	fi
done

printf '\nsymlink_sources (%d):\n' "${#symlink_sources[@]}"
if ((${#symlink_sources[@]})); then
	printf '  %s\n' "${symlink_sources[@]}"
fi

# For each of the symlink sources, check if a default yadm file exists

detected_default_files=()

for file in "${symlink_sources[@]}"; do
	default_file="${file}##default"
	if [[ -f "$default_file" ]]; then
		detected_default_files+=("$default_file")
	elif [[ "$file" != *".nano"* ]]; then
		echo "Warning: No default file found for symlink source '$file'. Expected '$default_file' to exist."
	fi
done



printf '\ndetected_default_files (%d):\n' "${#detected_default_files[@]}"
if ((${#detected_default_files[@]})); then
	printf '  %s\n' "${detected_default_files[@]}"
fi


# From those files, keep ones that are active symlink endpoints (targets)
active_symlink_endpoints=()
for f in "${files_with_hashes[@]}"; do
	file_abs=$(realpath -m "./$f")
	is_endpoint=0

	while IFS= read -r -d '' lnk; do
		target=$(readlink "$lnk" || true)
		[[ -z "$target" ]] && continue

		lnk_dir=$(dirname "$lnk")
		target_abs=$(realpath -m "$lnk_dir/$target")

		if [[ "$target_abs" == "$file_abs" ]]; then
			is_endpoint=1
			break
		fi
	done < <(find . -type l -print0)

	(( is_endpoint )) && active_symlink_endpoints+=("$f")
done

# Files with hashes that are not active symlink endpoints
inactive_yadm_symlinks=()
for f in "${files_with_hashes[@]}"; do
	is_inactive=1
	for endpoint in "${active_symlink_endpoints[@]}"; do
		if [[ "$f" == "$endpoint" ]]; then
			is_inactive=0
			break
		fi
	done
	(( is_inactive )) && inactive_yadm_symlinks+=("$f")
done


printf '\nactive_symlink_endpoints (%d):\n' "${#active_symlink_endpoints[@]}"
if ((${#active_symlink_endpoints[@]})); then
	printf '  %s\n' "${active_symlink_endpoints[@]}"
fi

printf '\ninactive_yadm_symlinks (%d):\n' "${#inactive_yadm_symlinks[@]}"
if ((${#inactive_yadm_symlinks[@]})); then
	printf '  %s\n' "${inactive_yadm_symlinks[@]}"
fi



def reset_default_symlinks() {
		for file in "${detected_default_files[@]}"; do
				symlink_source="${file%##default}"
				if [[ -L "$symlink_source" ]]; then
						echo "Resetting symlink: $symlink_source -> $file"
						rm "$symlink_source"
						ln -s "$file" "$symlink_source"
				else
						echo "Warning: Expected symlink source '$symlink_source' does not exist or is not a symlink."
				fi
		done
}

def test_pminformatics_symlinks() {
	for file in "${symlink_sources[@]}"; do
		if [[ "$file" == *"pminformatics"* ]]; then
			echo "Testing symlink: $file"
			if [[ -L "$file" ]]; then
				target=$(readlink "$file")
				echo "  Symlink points to: $target"
			else
				echo "  Warning: '$file' is not a symlink."
			fi
		fi
	done
	}

reset_default_symlinks()