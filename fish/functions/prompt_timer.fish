function prompt_timer
    set -l ms $CMD_DURATION

    if test $ms -lt 1000
        return
    end

    set_color yellow

    if test $ms -ge 60000
        set -l total_seconds (math "floor($ms / 1000)")
        set -l minutes (math "floor($total_seconds / 60)")
        set -l seconds (math "$total_seconds % 60")

        echo -n "⚡ "$minutes"m "$seconds"s"

    else if test $ms -ge 10000
        set -l seconds (math "$ms / 1000")
        echo -n "⚡ "$seconds"s"

    else
        set -l seconds (math "$ms / 1000")
        echo -n "⚡ "$seconds"s"
    end

    set_color normal
end
