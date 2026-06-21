#!/usr/bin/env bash
# Install claude completion for bash and/or zsh into user-level dirs.
# No need to edit ~/.bashrc (bash lazy-loads); zsh needs the dir on $fpath.
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"

# --- bash ---
bash_dir="${BASH_COMPLETION_USER_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/bash-completion}/completions"
mkdir -p "$bash_dir"
install -m 0644 "$here/completions/claude" "$bash_dir/claude"
echo "bash: installed $bash_dir/claude"

# --- zsh ---
zsh_dir="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/site-functions"
mkdir -p "$zsh_dir"
install -m 0644 "$here/completions/_claude" "$zsh_dir/_claude"
echo "zsh:  installed $zsh_dir/_claude"

echo
echo "bash: open a new shell, then:  claude --<Tab>"
echo "zsh:  if completion does not appear, add this to ~/.zshrc BEFORE 'compinit':"
echo "        fpath=(\"$zsh_dir\" \$fpath)"
echo "      then open a new shell (or run: autoload -U compinit && compinit)."
