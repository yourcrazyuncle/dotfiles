
function prompt_network

    # ───────────────────────────────────────────────
    # Detect active physical connections
    # ───────────────────────────────────────────────

    set -l wifi_if ""
    set -l eth_if ""

    for entry in (env LC_ALL=C nmcli -t -f DEVICE,TYPE,STATE device status 2>/dev/null)
        set -l fields (string split ":" -- "$entry")

        if test (count $fields) -lt 3
            continue
        end

        set -l device "$fields[1]"
        set -l type "$fields[2]"
        set -l state "$fields[3]"

        if not string match -q 'connected*' -- "$state"
            continue
        end

        switch "$type"
            case wifi
                if test -z "$wifi_if"
                    set wifi_if "$device"
                end

            case ethernet
                if test -z "$eth_if"
                    set eth_if "$device"
                end
        end
    end

    # ───────────────────────────────────────────────
    # Choose interface (Wi-Fi preferred)
    # ───────────────────────────────────────────────

    set -l interface ""

    if test -n "$wifi_if"

        set interface "$wifi_if"

        # Obtain SSID and signal strength

        set -l active_ap (env LC_ALL=C nmcli -t -e no -f IN-USE,SSID,SIGNAL device wifi list --rescan no ifname "$interface" 2>/dev/null | string match -r '^\*:.*:[0-9]+$' | head -n 1)

        set -l ssid ""
        set -l signal ""

        if test -n "$active_ap"
            set ssid (string replace -r '^\*:(.*):[0-9]+$' '$1' -- "$active_ap")
            set signal (string replace -r '^.*:([0-9]+)$' '$1' -- "$active_ap")
        end

        # Fallback to NetworkManager connection name

        if test -z "$ssid"
            set ssid (nmcli -g GENERAL.CONNECTION device show "$interface" 2>/dev/null)
        end

        if test -z "$ssid"
            set ssid "$interface"
        end

        set_color brgreen
        echo -n "󰖩 "

        set_color cyan
        echo -n "$ssid"

        # ───────────────────────────────────────────
        # Signal meter
        # ───────────────────────────────────────────

        if string match -rq '^[0-9]+$' -- "$signal"

            set_color brblack
            echo -n "  │  "

            set_color yellow
            echo -n "SIGNAL "

            set -l filled (math "floor($signal / 10)")
            set -l empty (math "10 - $filled")

            set_color brblue

            if test $filled -gt 0
                for i in (seq $filled)
                    echo -n "█"
                end
            end

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

    else if test -n "$eth_if"

        set interface "$eth_if"

        set_color brgreen
        echo -n "󰈀 "

        set_color yellow
        echo -n "ETHERNET"

    # ───────────────────────────────────────────────
    # No physical connection
    # ───────────────────────────────────────────────

    else

        set_color red
        echo -n "󰖪 NO WI-FI/ETHERNET"

    end

    # ───────────────────────────────────────────────
    # Second line: IP addresses
    # ───────────────────────────────────────────────

    echo
    echo -n "    "

    set -l has_ip false

    # Local IPv4 address

    if test -n "$interface"

        set -l local_ip (nmcli -g IP4.ADDRESS device show "$interface" 2>/dev/null | head -n 1 | cut -d/ -f1)

        if test -n "$local_ip"

            set_color blue
            echo -n "󰩟 $local_ip"

            set has_ip true
        end
    end

    # ───────────────────────────────────────────────
    # Tailscale IPv4 address
    # ───────────────────────────────────────────────

    set -l ts_ip (ip -4 addr show tailscale0 2>/dev/null | awk '/inet / {split($2,a,"/"); print a[1]; exit}')

    if test -n "$ts_ip"

        if test "$has_ip" = true
            set_color brblack
            echo -n "  │  "
        end

        set_color magenta
        echo -n "󰒃 $ts_ip"
    end

    set_color normal

end
