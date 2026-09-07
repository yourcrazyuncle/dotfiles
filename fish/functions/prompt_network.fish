function prompt_network
    # ───────────────────────────────────────────────
    # Find active physical connection
    # ───────────────────────────────────────────────

    set -l wifi_info (nmcli -t -f DEVICE,TYPE,STATE,CONNECTION device | string match 'wlan0:wifi:connected:*')
    set -l eth_info (nmcli -t -f DEVICE,TYPE,STATE,CONNECTION device | string match 'enp5s0:ethernet:connected:*')

    # ───────────────────────────────────────────────
    # Wi-Fi
    # ───────────────────────────────────────────────

    if test -n "$wifi_info"

        set -l ssid (string split ":" "$wifi_info")[4]

        set_color brgreen
        echo -n "󰖩 "

        set_color cyan
        echo -n "$ssid"

        # Signal strength
        set -l signal (nmcli -t -f IN-USE,SIGNAL,DEVICE dev wifi | string match '*:*:wlan0' | head -n1 | cut -d: -f2)

        if string match -rq '^[0-9]+$' -- "$signal"
            set_color brblack
            echo -n "  │  "

            set_color yellow
            echo -n "SIGNAL "

            set -l filled (math "floor($signal / 10)")
            set -l empty (math "10 - $filled")

            # Filled signal — dim blue
            set_color brblue

            if test $filled -gt 0
                for i in (seq $filled)
                    echo -n "█"
                end
            end

            # Empty signal — dark gray
            set_color brblack

            if test $empty -gt 0
                for i in (seq $empty)
                    echo -n "░"
                end
            end

            set_color yellow
            echo -n " $signal%"
        end

    # ───────────────────────────────────────────────
    # Ethernet
    # ───────────────────────────────────────────────

    else if test -n "$eth_info"

        set_color brgreen
        echo -n "󰈀 "

        set_color yellow
        echo -n "ETHERNET"

    # ───────────────────────────────────────────────
    # Offline
    # ───────────────────────────────────────────────

    else

        set_color red
        echo -n "󰖪 NETWORK OFFLINE"

        set_color normal
        return
    end

    # ───────────────────────────────────────────────
    # IP address
    # ───────────────────────────────────────────────

    set -l interface wlan0

    if test -z "$wifi_info"
        set interface enp5s0
    end

    set -l ip (nmcli -g IP4.ADDRESS device show "$interface" 2>/dev/null | head -n1 | cut -d/ -f1)

    if test -n "$ip"
        set_color brblack
        echo -n "  │  "

        set_color blue
        echo -n "󰩟 $ip"
    end

    # ───────────────────────────────────────────────
    # Tailscale
    # ───────────────────────────────────────────────

    set -l ts_ip (ip -4 addr show tailscale0 2>/dev/null | awk '/inet / {print $2}' | cut -d/ -f1)

    if test -n "$ts_ip"
        set_color brblack
        echo -n "  │  "

        set_color magenta
        echo -n "󰒃 $ts_ip"
    end

    set_color normal
end
