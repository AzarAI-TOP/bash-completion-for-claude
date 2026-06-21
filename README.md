# bash-completion-for-claude

Tab completion for the [`claude`](https://github.com/anthropics/claude-code)
CLI (Claude Code) in **bash** and **zsh**.

Claude Code ships **no** built-in completion generator (the client is
closed-source, so `source <(claude completion bash)` is not possible). Static
flag lists go stale on every release. These scripts instead **parse
`claude --help` at runtime** and cache the result per version, so completion
always matches the `claude` you actually have installed.

## Install

```bash
git clone https://github.com/AzarAI-TOP/bash-completion-for-claude.git
cd bash-completion-for-claude
./install.sh
```

Then, in a new shell:

```
claude --<Tab>      # options:     --model --resume --print ...
claude <Tab>        # subcommands: agents auth mcp plugin update ...
```

`install.sh` installs both:

| shell | installed to | loading |
|-------|--------------|---------|
| bash  | `${XDG_DATA_HOME:-~/.local/share}/bash-completion/completions/claude` | lazy-loaded by bash-completion; no `~/.bashrc` edit |
| zsh   | `${XDG_DATA_HOME:-~/.local/share}/zsh/site-functions/_claude` | autoloaded via `compinit` if the dir is on `$fpath` |

For **zsh**, the install dir must be on `$fpath` *before* `compinit`. If
completion does not show up, add to `~/.zshrc`:

```zsh
fpath=("${XDG_DATA_HOME:-$HOME/.local/share}/zsh/site-functions" $fpath)
autoload -U compinit && compinit
```

## How it works

- On first completion the function runs `claude --help`, extracts every
  `--option` and every subcommand from the `Commands:` section, and caches the
  list under `${XDG_CACHE_HOME:-~/.cache}/claude-completion/words-<version>`.
- Later completions read the cache (instant). After you upgrade Claude Code the
  version changes, so a fresh list is generated automatically.
- A few path-taking options (`--add-dir`, `--settings`, `--mcp-config`,
  `--debug-file`, `--system-prompt-file`, `--append-system-prompt-file`) fall
  back to file/dir completion.

## Requirements

- bash: `bash-completion` (provides the lazy-load dir and `_init_completion` /
  `_filedir`)
- zsh: `compinit` enabled (standard)
- `claude` on `PATH`

## Uninstall

```bash
rm -f "${XDG_DATA_HOME:-$HOME/.local/share}/bash-completion/completions/claude"
rm -f "${XDG_DATA_HOME:-$HOME/.local/share}/zsh/site-functions/_claude"
rm -rf "${XDG_CACHE_HOME:-$HOME/.cache}/claude-completion"
```

## License

MIT
