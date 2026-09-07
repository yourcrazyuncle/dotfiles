function prompt_context
    # ───────────────────────────────────────────────
    # Determine operational context
    # ───────────────────────────────────────────────

    set -l is_root false
    set -l is_ssh false

    if test (id -u) -eq 0
        set is_root true
    end

    if set -q SSH_CONNECTION; or set -q SSH_CLIENT; or set -q SSH_TTY
        set is_ssh true
    end

    # ───────────────────────────────────────────────
    # Remote session
    # ───────────────────────────────────────────────

    if $is_ssh
        set_color red
        echo -n "󰒃 SSH REMOTE"

        if $is_root
            set_color red
            echo -n "  │  "
            echo -n "󰀪 ROOT"
        end

    # ───────────────────────────────────────────────
    # Local root
    # ───────────────────────────────────────────────

    else if $is_root
        set_color red
        echo -n "󰀪 LOCAL ROOT"

    # ───────────────────────────────────────────────
    # Normal local session
    # ───────────────────────────────────────────────

    else
        set_color brgreen
        echo -n "󰆍 LOCAL"
    end

    set_color normal
end
