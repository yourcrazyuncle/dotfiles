function fish_prompt
    set -l last_status $status

    # ═══════════════════════════════════════════════
    # HEADER
    # ═══════════════════════════════════════════════

    set_color cyan
    echo -n "╭─╼ "

    # Root warning
    if test (id -u) -eq 0
        set_color red
        echo -n "󰀪 ROOT"
    else
        set_color brgreen
        echo -n "󰣇 "(whoami)
    end

    set_color brblack
    echo -n "@"

    set_color yellow
    echo -n (hostname -s)

    # SSH indicator
    if set -q SSH_CONNECTION
        set_color red
        echo -n "  ⚠ SSH"
    end

    # ═══════════════════════════════════════════════
    # PATH
    # ═══════════════════════════════════════════════

    echo
    set_color cyan
    echo -n "│  "

    set_color blue
    echo -n "󰉋 "

    set_color brblue
    echo -n (pwd)

    # ═══════════════════════════════════════════════
    # GIT
    # ═══════════════════════════════════════════════

    if command git rev-parse --is-inside-work-tree >/dev/null 2>&1
        echo
        set_color cyan
        echo -n "│  "
        prompt_git
    end

    # ═══════════════════════════════════════════════
    # SYSTEM
    # ═══════════════════════════════════════════════

    echo
set_color cyan
echo -n "│  "
prompt_system

if test $CMD_DURATION -ge 1000
    echo
    set_color cyan
    echo -n "│  "
    prompt_timer
end

echo
set_color cyan
echo -n "│  "
prompt_network


    # ═══════════════════════════════════════════════
    # STATUS
    # ═══════════════════════════════════════════════

    echo
    set_color cyan
    echo -n "│  "

    if test $last_status -eq 0
        set_color brgreen
        echo -n " STATUS OK"
    else
        set_color red
        echo -n " EXIT $last_status"
    end

    # ═══════════════════════════════════════════════
    # INPUT
    # ═══════════════════════════════════════════════

    echo
    set_color cyan
    echo -n "╰─╼ "

    if test $last_status -eq 0
        set_color brmagenta
    else
        set_color red
    end

    echo -n "❯ "

    set_color normal
end
