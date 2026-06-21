#!/usr/bin/env bash
# Install claude shell completion. See ./install.sh --help for usage.
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"

usage() {
    cat <<'USAGE'
Install claude shell completion.

Usage:
  ./install.sh          Detect the current shell ($SHELL) and install it.
  ./install.sh bash     Install for bash.
  ./install.sh zsh      Install for zsh.
  ./install.sh fish     Install for fish.
  ./install.sh all      Install for all three.
USAGE
}

install_bash() {
    local dir="${BASH_COMPLETION_USER_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/bash-completion}/completions"
    mkdir -p "$dir"
    install -m 0644 "$here/completions/claude" "$dir/claude"
    echo "bash: installed $dir/claude"
    echo "bash: open a new shell, then:  claude --<Tab>"
}

install_zsh() {
    local dir="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/site-functions"
    mkdir -p "$dir"
    install -m 0644 "$here/completions/_claude" "$dir/_claude"
    echo "zsh:  installed $dir/_claude"
    echo "zsh:  if completion does not appear, add to ~/.zshrc BEFORE 'compinit':"
    echo "        fpath=(\"$dir\" \$fpath)"
    echo "      then open a new shell (or run: autoload -U compinit && compinit)."
}

install_fish() {
    local dir="${XDG_CONFIG_HOME:-$HOME/.config}/fish/completions"
    mkdir -p "$dir"
    install -m 0644 "$here/completions/claude.fish" "$dir/claude.fish"
    echo "fish: installed $dir/claude.fish"
    echo "fish: open a new shell, then:  claude --<Tab>"
}

detect_shell() {
    case "$(basename "${SHELL:-}")" in
        bash) echo bash ;;
        zsh)  echo zsh ;;
        fish) echo fish ;;
        *)    echo unknown ;;
    esac
}

target="${1:-}"

if [ -z "$target" ]; then
    target="$(detect_shell)"
    if [ "$target" = unknown ]; then
        echo "Could not detect a supported shell from \$SHELL (${SHELL:-unset})." >&2
        echo "Supported shells: bash, zsh, fish." >&2
        echo "Install explicitly, e.g.:  ./install.sh bash" >&2
        exit 1
    fi
    echo "Detected current shell: $target"
fi

case "$target" in
    bash) install_bash ;;
    zsh)  install_zsh ;;
    fish) install_fish ;;
    all)  install_bash; echo; install_zsh; echo; install_fish ;;
    -h|--help|help) usage ;;
    *)
        echo "Unsupported shell: '$target'. Supported: bash, zsh, fish (or 'all')." >&2
        echo >&2
        usage >&2
        exit 1
        ;;
esac
