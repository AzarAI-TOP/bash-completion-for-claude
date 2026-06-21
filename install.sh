#!/usr/bin/env bash
# Install the claude bash-completion script into the user-level
# bash-completion directory (lazy-loaded, no ~/.bashrc edit needed).
set -euo pipefail
src="$(cd "$(dirname "$0")" && pwd)/completions/claude"
dest_dir="${BASH_COMPLETION_USER_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/bash-completion}/completions"
mkdir -p "$dest_dir"
install -m 0644 "$src" "$dest_dir/claude"
echo "Installed: $dest_dir/claude"
echo "Open a new shell (or: source \"$dest_dir/claude\"), then: claude --<Tab>"
