#!/usr/bin/env bash
#  ███████╗██╗   ██╗███████╗████████╗███████╗███╗   ███╗    ██╗   ██╗ █████╗ ██████╗ ███████╗
#  ██╔════╝╚██╗ ██╔╝██╔════╝╚══██╔══╝██╔════╝████╗ ████║    ██║   ██║██╔══██╗██╔══██╗██╔════╝
#  ███████╗ ╚████╔╝ ███████╗   ██║   █████╗  ██╔████╔██║    ██║   ██║███████║██████╔╝███████╗
#  ╚════██║  ╚██╔╝  ╚════██║   ██║   ██╔══╝  ██║╚██╔╝██║    ╚██╗ ██╔╝██╔══██║██╔══██╗╚════██║
#  ███████║   ██║   ███████║   ██║   ███████╗██║ ╚═╝ ██║     ╚████╔╝ ██║  ██║██║  ██║███████║
#  ╚══════╝   ╚═╝   ╚══════╝   ╚═╝   ╚══════╝╚═╝     ╚═╝      ╚═══╝  ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝


CONFIG_FILE="$HOME/.config/bspwm/src/config/system.ini"
SFILE="$HOME/.config/bspwm/src/.sys"

# Check if the .sys file already exists
[[ -f "$SFILE" ]] && exit 0 # The file exists, exit without doing anything

# Function to get and set values
function setup_system_vars() {
    # Get network information (interface and type of connection)
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

    # Update the config file with network info
    if grep -q "^sys_network_interface = " "$CONFIG_FILE"; then
        sed -i "/^sys_network_interface = /c\\$interface_line" "$CONFIG_FILE"
    else
        echo "$interface_line" >> "$CONFIG_FILE"
    fi

    if grep -q "^sys_connection_type = " "$CONFIG_FILE"; then
        sed -i "/^sys_connection_type = /c\\$connection_type_line" "$CONFIG_FILE"
    else
        echo "$connection_type_line" >> "$CONFIG_FILE"
    fi

    # Graphics card (backlight)
    CARD=$(find /sys/class/backlight -maxdepth 1 -type l | head -n1 | xargs basename)
    [[ -n "$CARD" ]] && sed -i "s/sys_graphics_card = .*/sys_graphics_card = $CARD/" "$CONFIG_FILE"

    # Battery and adapter
    BATTERY=$(find /sys/class/power_supply -maxdepth 1 -type l -name "BAT*" | head -n1 | xargs basename)
    ADAPTER=$(find /sys/class/power_supply -maxdepth 1 -type l -name "A[CD]*" | head -n1 | xargs basename)

    [[ -n "$BATTERY" ]] && sed -i "s/sys_battery = .*/sys_battery = $BATTERY/" "$CONFIG_FILE"
    [[ -n "$ADAPTER" ]] && sed -i "s/sys_adapter = .*/sys_adapter = $ADAPTER/" "$CONFIG_FILE"

    # Trying to determine the best font size, based on your resolution.
    read -r screen_width screen_height < <(xdpyinfo | awk '/dimensions:/ {print $2}' | tr 'x' ' ')

    if [ "$screen_width" -le 1366 ] && [ "$screen_height" -le 768 ]; then
        font_size=9
    elif [ "$screen_width" -le 1600 ] && [ "$screen_height" -le 900 ]; then
        font_size=10
    elif [ "$screen_width" -le 1920 ] && [ "$screen_height" -le 1080 ]; then
        font_size=10
    elif [ "$screen_width" -le 2560 ] && [ "$screen_height" -le 1440 ]; then
        font_size=11
    elif [ "$screen_width" -le 3840 ] && [ "$screen_height" -le 2160 ]; then
        font_size=12
    else
        font_size=10
    fi

    sed -i "s/size = [0-9]*/size = $font_size/" ~/.config/alacritty/fonts.toml
}

# Ejecutar la configuración
setup_system_vars

# Crear el archivo .sys para indicar que la configuración ya se ha realizado
touch "$SFILE"