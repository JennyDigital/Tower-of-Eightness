#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
repo_root="$(cd -- "$script_dir/.." && pwd -P)"

if ! git -C "$repo_root" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
	echo "Error: not a git repository: $repo_root" >&2
	exit 1
fi

git -C "$repo_root" add -A

if git -C "$repo_root" diff --cached --quiet; then
	echo "No staged changes to commit."
	git -C "$repo_root" status --short --branch
	exit 0
fi

if [[ $# -gt 0 ]]; then
	git -C "$repo_root" commit -m "$*"
else
	git -C "$repo_root" commit
fi

if git -C "$repo_root" rev-parse --abbrev-ref --symbolic-full-name '@{u}' >/dev/null 2>&1; then
	git -C "$repo_root" push
else
	current_branch="$(git -C "$repo_root" rev-parse --abbrev-ref HEAD)"
	git -C "$repo_root" push -u origin "$current_branch"
fi

git -C "$repo_root" status --short --branch
