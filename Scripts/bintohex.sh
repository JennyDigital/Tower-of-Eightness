#!/usr/bin/env bash

set -euo pipefail

usage() {
	echo "Usage: $0 <input-binary-file> <output-text-file>"
}

if [[ $# -ne 2 ]]; then
	usage
	exit 1
fi

if ! command -v hexdump >/dev/null 2>&1; then
	echo "Error: required command 'hexdump' not found in PATH." >&2
	exit 1
fi

input_file="$1"
output_file="$2"

if [[ ! -f "$input_file" ]]; then
	echo "Error: input file not found: $input_file" >&2
	exit 1
fi

output_dir="$(dirname -- "$output_file")"
mkdir -p -- "$output_dir"

tmp1="$(mktemp)"
tmp2="$(mktemp)"
tmp3="$(mktemp)"
trap 'rm -f -- "$tmp1" "$tmp2" "$tmp3"' EXIT

printf 'S\r' > "$tmp1"
printf '@@\r' > "$tmp2"
hexdump -v -e '/1 "%02X\r"' "$input_file" > "$tmp3"
cat "$tmp1" "$tmp3" "$tmp2" > "$output_file"

echo "Wrote output to: $output_file"

