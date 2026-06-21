# bash-completion-for-claude

Tab completion for the [`claude`](https://github.com/anthropics/claude-code)
CLI (Claude Code) in **bash**.

Claude Code ships **no** built-in completion generator (the client is
closed-source, so `source <(claude completion bash)` is not possible). Static
flag lists go stale on every release. This script instead **parses
`claude --help` at runtime** and caches the result per version, so completion
always matches the `claude` you actually have installed.

## Install

```bash
git clone https://github.com/AzarAI-TOP/bash-completion-for-claude.git
cd bash-completion-for-claude
./install.sh
```

Open a new shell, then:

```
claude --<Tab>
claude <Tab>        # subcommands: agents auth mcp plugin update ...
```

`install.sh` copies `completions/claude` into your user-level
bash-completion directory
(`${XDG_DATA_HOME:-~/.local/share}/bash-completion/completions/claude`),
which bash-completion **lazy-loads** the first time you complete `claude`.
No `~/.bashrc` edit is required.

## How it works

- On first completion, the function runs `claude --help`, extracts every
  `--option` and every subcommand from the `Commands:` section, and caches
  the list under `${XDG_CACHE_HOME:-~/.cache}/claude-completion/words-<version>`.
- Subsequent completions read the cache (instant). After you upgrade Claude
  Code the version changes, so a fresh list is generated automatically.
- A few path-taking options (`--add-dir`, `--settings`, `--mcp-config`,
  `--debug-file`, `--system-prompt-file`, `--append-system-prompt-file`)
  fall back to file/dir completion.

## Requirements

- `bash-completion` (provides the lazy-load dir and the `_init_completion`
  / `_filedir` helpers)
- `claude` on `PATH`

## Uninstall

```bash
rm -f "${XDG_DATA_HOME:-$HOME/.local/share}/bash-completion/completions/claude"
rm -rf "${XDG_CACHE_HOME:-$HOME/.cache}/claude-completion"
```

## License

MIT
