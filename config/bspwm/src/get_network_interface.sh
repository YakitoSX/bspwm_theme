#!/bin/bash
set -euo pipefail

config_file="$HOME/.config/bspwm/src/config/system.ini"

interface_info=$(nmcli -t -f DEVICE,TYPE,STATE device status | grep -E 'wifi|ethernet' | grep 'connected')
interface=$(echo "$interface_info" | cut -d: -f1)
connection_type=$(echo "$interface_info" | cut -d: -f2)

if [[ -z "$interface" ]]; then
  interface_line="sys_network_interface = "
  connection_type_line="sys_connection_type = "
else
  interface_line="sys_network_interface = $interface"
  if [[ "$connection_type" == "wifi" ]]; then
    connection_type_line="sys_connection_type = wireless"
  elif [[ "$connection_type" == "ethernet" ]]; then
    connection_type_line="sys_connection_type = wired"
  fi
fi

sed -i "/^sys_network_interface = /c\\$interface_line" "$config_file" || echo "$interface_line" >> "$config_file"
sed -i "/^sys_connection_type = /c\\$connection_type_line" "$config_file" || echo "$connection_type_line" >> "$config_file"