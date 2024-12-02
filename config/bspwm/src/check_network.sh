#!/bin/bash
set -euo pipefail

config_file="$HOME/.config/bspwm/src/config/system.ini"

interface_info=$(nmcli -t -f DEVICE,TYPE,STATE device status | grep -E 'wifi|ethernet' | grep 'connected')
interface=$(echo "$interface_info" | cut -d: -f1)
connection_type=$(echo "$interface_info" | cut -d: -f2)

if [[ -z "$interface" ]]; then
    icon=""
else
    icon=""
    interface_line="sys_network_interface = $interface"

    if grep -q "^sys_network_interface = " "$CONFIG_FILE"; then
        sed -i "/^sys_network_interface = /c\\$interface_line" "$CONFIG_FILE"
    else
        echo "$interface_line" >> "$CONFIG_FILE"
    fi
fi

echo "%{A1:OpenApps --netmanager:}$icon%{A}"