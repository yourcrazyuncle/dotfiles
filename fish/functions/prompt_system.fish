function prompt_system
    # ───────────────────────────────────────────────
    # Time
    # ───────────────────────────────────────────────

    set_color brcyan
    echo -n " "(date "+%H:%M:%S")

    # ───────────────────────────────────────────────
    # CPU usage
    # ───────────────────────────────────────────────

    set -l cpu_usage (top -bn1 | awk '/Cpu\(s\)/ {print 100 - $8}' | cut -d. -f1)

    set_color brblack
    echo -n "  │  "

    set_color yellow
    echo -n " CPU "$cpu_usage"%"

    # ───────────────────────────────────────────────
    # Memory
    # ───────────────────────────────────────────────

    set -l mem_total (free -h | awk '/^Mem:/ {print $2}')
    set -l mem_used (free -h | awk '/^Mem:/ {print $3}')

    set_color brblack
    echo -n "  │  "

    set_color blue
    echo -n "󰍛 "$mem_used"/"$mem_total

    set_color normal
end
