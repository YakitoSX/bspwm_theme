#!/usr/bin/env bash

options=(
    "󰈆"
    ""
    ""
)

rofi_cmd() {
	rofi -dmenu \
		-p "Goodbye ${USER}" \
		-mesg "Uptime: $(uptime -p | sed -e 's/up //g')" \
		-no-click-to-exit \
		-theme "$HOME"/.config/bspwm/src/rofi-themes/PowerMenu.rasi
}

chosen=$(printf "%s\n" "${options[@]}" | rofi_cmd)

case $chosen in
    "")
        systemctl poweroff
        ;;
    "")
        systemctl reboot
        ;;
    "󰈆")
        bspc quit
        ;;
esac
