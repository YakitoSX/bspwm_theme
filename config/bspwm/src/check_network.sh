#!/bin/bash
set -euo pipefail

config_file="$HOME/.config/bspwm/src/config/system.ini"

# Check if networking is enabled
if ! nmcli networking; then
    icon=" "
    color="#FF0000"
else
    # Check for connected interfaces
    interface_info=$(nmcli -t -f DEVICE,TYPE,STATE device status | grep -E 'wifi|ethernet' | grep 'connected')
    
    if [[ -z "$interface_info" ]]; then
        icon=" "
        color="#FF0000"
    else
        interface=$(echo "$interface_info" | cut -d: -f1)
        icon=" "
        color="#00FF00"
        
        interface_line="sys_network_interface = $interface"
        if grep -q "^sys_network_interface = " "$config_file"; then
            sed -i "/^sys_network_interface = /c\\$interface_line" "$config_file"
        else
            echo "$interface_line" >> "$config_file"
        fi
    fi
fi

echo "%{F$color}%{A1:OpenApps --netmanager:}$icon%{A}%{F-}"