#!/usr/bin/env bash
#   █████╗ ██████╗ ██████╗ ███████╗    ██╗      █████╗ ██╗   ██╗███╗   ██╗ ██████╗██╗  ██╗███████╗██████╗
#  ██╔══██╗██╔══██╗██╔══██╗██╔════╝    ██║     ██╔══██╗██║   ██║████╗  ██║██╔════╝██║  ██║██╔════╝██╔══██╗
#  ███████║██████╔╝██████╔╝███████╗    ██║     ███████║██║   ██║██╔██╗ ██║██║     ███████║█████╗  ██████╔╝
#  ██╔══██║██╔═══╝ ██╔═══╝ ╚════██║    ██║     ██╔══██║██║   ██║██║╚██╗██║██║     ██╔══██║██╔══╝  ██╔══██╗
#  ██║  ██║██║     ██║     ███████║    ███████╗██║  ██║╚██████╔╝██║ ╚████║╚██████╗██║  ██║███████╗██║  ██║
#  ╚═╝  ╚═╝╚═╝     ╚═╝     ╚══════╝    ╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
#	Script to control prefered apps to launch for all themes
#	Author: z0mbi3
#	url:    https://github.com/gh0stzk/dotfiles

WIDGET_DIR="$HOME/.config/bspwm/eww"

case "$1" in
    --menu)
        rofi -show drun -theme "$HOME"/.config/bspwm/src/rofi-themes/Launcher.rasi 
        ;;
    --xdg-terminal)
        xdg-terminal
        ;;
    --floating)
        xdg-terminal --floating
        ;;
    --update)
        xdg-terminal --update 
        ;;
    --checkupdates)
        xdg-terminal --checkupdates
        ;;
    --netmanager)
		"$HOME"/.config/bspwm/src/NetManagerDM.sh
		;;
	--bluetooth)
		"$HOME"/.config/bspwm/src/rofi-bluetooth.sh
		;;
	--clipboard)
		rofi -modi "clipboard:greenclip print" -theme "$HOME"/.config/bspwm/src/rofi-themes/Clipboard.rasi -show clipboard -run-command '{cmd}'
		;;
	--screenshot)
		"$HOME"/.config/bspwm/src/ScreenShoTer.sh
		;;
	--powermenu)
        PowerMenu
        ;;
    --android)
		"$HOME"/.config/bspwm/src/AndroidMount.sh
		;;
    --ranger)
        xdg-terminal --ranger
        ;;
    --nvim)
        xdg-terminal --nvim
        ;;
    --music)
        xdg-terminal --music
        ;;
    --fetch)
        xdg-terminal --fetch
        ;;
        # Apps
    --filemanager)
        thunar
        ;;
    --browser)
        firefox
        ;;
    --editor)
        gedit
        ;;
    --soundcontrol)
        pavucontrol
        ;;
        # Eww Widgets
    --KeyHelp)
		eww -c "$WIDGET_DIR" open --toggle csheet
		;;
    --calendar)
        eww -c "$WIDGET_DIR" open --toggle date
        ;;
    *)
        echo "Invalid Option"
        ;;
esac
