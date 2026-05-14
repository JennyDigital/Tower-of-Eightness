#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
repo_root="$(cd -- "$script_dir/.." && pwd -P)"

source_bin="$repo_root/Source/ToE_ACIA.65b"
full_bin="$repo_root/Source/ToE_ACIAfull.bin"
prebuilt_dir="$repo_root/Prebuilt_ROMs"
chip_type="${MINIPRO_CHIP:-28C256}"

if [[ ! -f "$source_bin" ]]; then
	echo "Error: source binary not found: $source_bin" >&2
	exit 1
fi

mkdir -p -- "$prebuilt_dir"
cat "$source_bin" "$source_bin" > "$full_bin"
cp -- "$full_bin" "$prebuilt_dir/ToE_ACIAfull.bin"
cp -- "$source_bin" "$prebuilt_dir/ToE_ACIA.bin"

if [[ "${SKIP_PROGRAM:-0}" == "1" ]]; then
	echo "SKIP_PROGRAM=1 set, skipping EEPROM programming."
	exit 0
fi

if ! command -v minipro >/dev/null 2>&1; then
	echo "Error: required command 'minipro' not found in PATH." >&2
	echo "Set SKIP_PROGRAM=1 to only generate/copy binary outputs." >&2
	exit 1
fi

minipro -u -P -p "$chip_type" -w "$full_bin"
echo "Done"





