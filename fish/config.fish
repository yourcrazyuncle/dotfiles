# ~/.config/fish/config.fish

# ─────────────────────────────────────
# PATH
# ─────────────────────────────────────

fish_add_path ~/.local/bin
fish_add_path ~/bin


# ─────────────────────────────────────
# Aliases
# ─────────────────────────────────────

alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'

alias c='clear'
alias cls='clear'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias brave="brave --incognito"

alias vlc="env QT_SCALE_FACTOR=1.25 vlc"

alias grep='grep --color=auto'


# ─────────────────────────────────────
# Git shortcuts
# # ─────────────────────────────────────
#
# alias gs='git status'
# alias ga='git add'
# alias gc='git commit'
# alias gp='git push'
# alias gl='git log --oneline --graph --decorate'


# ─────────────────────────────────────
# Editor
# ─────────────────────────────────────

set -gx EDITOR nvim
set -gx VISUAL nvim


# ─────────────────────────────────────
# Useful environment variables
# ─────────────────────────────────────

set -gx TERM xterm-256color


# ─────────────────────────────────────
# Greeting
# ─────────────────────────────────────

set -g fish_greeting "LOGGED: Commanding officer aboard.

XO Bash stands relieved.

Captain Ahab has the deck."


# ─────────────────────────────────────
# Interactive configuration
# ─────────────────────────────────────

if status is-interactive
    # Interactive-only configuration goes here
end
