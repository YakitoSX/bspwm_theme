#!/bin/bash
set -euo pipefail

config_file="$HOME/.config/bspwm/src/config/system.ini"

# Get information about connected interfaces
interface_info=$(nmcli -t -f DEVICE,TYPE,STATE device status | grep -E 'wifi|ethernet' | grep 'connected' || true)

if [[ -z "$interface_info" ]]; then
    # No active interfaces
    icon=" "
    color="#FF0000"  # Red for disconnected
else
    # An interface is connected, check if it has an IP address
    interface=$(echo "$interface_info" | cut -d: -f1)
    ip_address=$(nmcli -g IP4.ADDRESS device show "$interface" | head -n 1 || true)

    if [[ -z "$ip_address" ]]; then
        # Interface connected but no IP address
        icon=" "
        color="#FFFF00"  # Yellow for connected but no internet
    else
        # Interface connected with internet available
        icon=" "
        color="#00FF00"  # Green for connected with internet

        # Update the configuration file
        interface_line="sys_network_interface = $interface"
        if grep -q "^sys_network_interface = " "$config_file"; then
            sed -i "/^sys_network_interface = /c\\$interface_line" "$config_file"
        else
            echo "$interface_line" >> "$config_file"
        fi
    fi
fi

# Output for Polybar
echo "%{F$color}%{A1:OpenApps --netmanager:}$icon%{A}%{F-}"