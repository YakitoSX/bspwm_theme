#!/bin/bash
set -euo pipefail

config_file="$HOME/.config/bspwm/src/config/system.ini"

interface_info=$(nmcli -t -f DEVICE,TYPE,STATE device status | grep -E 'wifi|ethernet' | grep 'connected')

if [[ -z "$interface_info" ]]; then
    # No active interface
    icon=" "
    color="#FF0000"  # Red for disconnected
else
    # Interface is connected, check for IP address
    interface=$(echo "$interface_info" | cut -d: -f1)
    ip_address=$(nmcli device show "$interface" | grep 'IP4.ADDRESS' | awk '{print $2}')

    if [[ -z "$ip_address" ]]; then
        # Interface connected, but no IP address, assuming no internet
        icon=" "
        color="#FFFF00"  # Yellow for connected but no internet
    else
        # Interface is connected with a valid IP address (internet available)
        icon=" "
        color="#00FF00"  # Green for connected with internet

        interface_line="sys_network_interface = $interface"
        if grep -q "^sys_network_interface = " "$config_file"; then
            sed -i "/^sys_network_interface = /c\\$interface_line" "$config_file"
        else
            echo "$interface_line" >> "$config_file"
        fi
    fi
fi

echo "%{F$color}%{A1:OpenApps --netmanager:}$icon%{A}%{F-}"