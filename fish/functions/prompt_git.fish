function prompt_git
    command git rev-parse --is-inside-work-tree >/dev/null 2>&1
    or return

    set -l branch (command git branch --show-current 2>/dev/null)

    if test -z "$branch"
        set branch "detached"
    end

    set_color brmagenta
    echo -n "󰊢 $branch"

    # Modified files
    set -l changed (command git status --porcelain 2>/dev/null | wc -l | string trim)

    if test "$changed" -gt 0
        set_color yellow
        echo -n " ✚$changed"
    end

    # Ahead / behind
    set -l upstream (command git rev-parse --abbrev-ref '@{upstream}' 2>/dev/null)

    if test -n "$upstream"
        set -l ahead (command git rev-list --count "$upstream"..HEAD 2>/dev/null)
        set -l behind (command git rev-list --count HEAD.."$upstream" 2>/dev/null)

        if test "$ahead" -gt 0
            set_color green
            echo -n " ↑$ahead"
        end

        if test "$behind" -gt 0
            set_color red
            echo -n " ↓$behind"
        end
    end

    set_color normal
end
