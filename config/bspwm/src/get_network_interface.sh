#!/bin/bash
interface=$(nmcli -t -f DEVICE,TYPE,STATE device status | grep -E 'wifi|ethernet' | grep 'connected' | cut -d: -f1)

if [[ -z "$interface" ]]; then
  echo "none"
else
  echo "$interface"
fi