function fish_preexec --on-event fish_preexec
    set -g __prompt_start_time (date +%s%3N)
end
