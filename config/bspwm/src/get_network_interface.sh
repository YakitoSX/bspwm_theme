#!/bin/bash
nmcli -t -f DEVICE,TYPE,STATE device status | grep -E 'wifi|ethernet' | grep -E 'connected' | cut -d: -f1