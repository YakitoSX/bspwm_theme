#!/bin/bash
set -euo pipefail

icon=" "
color="#F7768E"  # Red

# Check for default gateway
if ip route | grep -q "default"; then
    # Active connection with internet
    color="#9ECE6A"  # Green
elif nmcli -t -f DEVICE,TYPE,STATE device status | grep -E 'wifi|ethernet' | grep -q 'connected'; then
        # Active interface, no internet
        color="#FFFF00"  # Yellow
fi

# Output for Polybar
echo "%{F$color}%{A1:OpenApps --netmanager:}$icon%{A}%{F-}"