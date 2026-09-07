function fish_postexec --on-event fish_postexec
    if set -q __prompt_start_time
        set -l end_time (date +%s%3N)
        set -g __prompt_duration (math "$end_time - $__prompt_start_time")
    end
end
