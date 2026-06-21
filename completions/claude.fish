# Dynamic fish completion for the `claude` CLI (Claude Code).
#
# Parses `claude --help` and caches the result per version under
# $XDG_CACHE_HOME/claude-completion, then registers completions -- so the list
# always matches the installed `claude` instead of a hard-coded flag set.
#
# Install: place this file as
#   ${XDG_CONFIG_HOME:-~/.config}/fish/completions/claude.fish
# fish autoloads it the first time you complete `claude`.

function __claude_completion_words
    set -l cache_root $HOME/.cache
    test -n "$XDG_CACHE_HOME"; and set cache_root $XDG_CACHE_HOME
    set -l cache_dir $cache_root/claude-completion
    set -l ver (claude --version 2>/dev/null | string split -f1 ' ')
    test -n "$ver"; or set ver unknown
    set -l words_file $cache_dir/words-$ver
    if not test -s $words_file
        set -l help (claude --help 2>/dev/null)
        test -n "$help"; or return 1
        mkdir -p $cache_dir 2>/dev/null
        begin
            printf '%s\n' $help | grep -oE -- '--[a-zA-Z][a-zA-Z0-9-]*'
            printf '%s\n' $help | awk '/^Commands:/{f=1; next} f && /^  [a-z]/{print $1}' | sed 's/|.*//'
        end | sort -u >$words_file
    end
    cat $words_file
end

set -l __claude_pathopts add-dir settings mcp-config debug-file system-prompt-file append-system-prompt-file

for __claude_w in (__claude_completion_words)
    switch $__claude_w
        case '--*'
            set -l __claude_opt (string sub -s 3 -- $__claude_w)
            if contains -- $__claude_opt $__claude_pathopts
                complete -c claude -l $__claude_opt -r -F
            else
                complete -c claude -l $__claude_opt
            end
        case '*'
            complete -c claude -n __fish_use_subcommand -a $__claude_w
    end
end
