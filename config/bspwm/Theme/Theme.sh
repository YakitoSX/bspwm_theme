#!/usr/bin/env bash

# Terminate or reload existing processes if necessary.
. "${HOME}"/.config/bspwm/src/Process.bash

# Vars config
# Bspwm border		# Normal border color	# Focused border color
BORDER_WIDTH="0"	NORMAL_BC="#414868"		FOCUSED_BC="#bb9af7"

# Fade true|false	# Shadows true|false	# Corner radius		# Shadow color			# Animations true|false
P_FADE="true"		P_SHADOWS="true"		P_CORNER_R="6"		SHADOW_C="#000000"		ANIMATIONS="true"

# (Tokyo Night) colorscheme
bg="#1a1b26"  fg="#c0caf5"

black="#15161e"   red="#f7768e"   green="#9ece6a"   yellow="#e0af68"
blackb="#414868"  redb="#f7768e"  greenb="#9ece6a"  yellowb="#e0af68"

blue="#7aa2f7"   magenta="#bb9af7"   cyan="#7dcfff"   white="#a9b1d6"
blueb="#7aa2f7"  magentab="#bb9af7"  cyanb="#7dcfff"  whiteb="#c0caf5"

# Gtk theme vars
gtk_theme="Nordic-darker"	gtk_icons="Papirus-Dark"	gtk_cursor="catppuccin-mocha-dark-cursors"

# Set bspwm configuration
set_bspwm_config() {
	bspc config border_width ${BORDER_WIDTH}
	bspc config top_padding 50
	bspc config bottom_padding 1
	bspc config left_padding 1
	bspc config right_padding 1
	bspc config normal_border_color "${NORMAL_BC}"
	bspc config focused_border_color "${FOCUSED_BC}"
	bspc config presel_feedback_color "${blue}"
}

# Set compositor configuration
set_picom_config() {
	picom_conf_file="$HOME/.config/bspwm/src/config/picom.conf"
	picom_rules_file="$HOME/.config/bspwm/src/config/picom-rules.conf"

	# Configuración de picom
	sed -i "$picom_conf_file" \
		-e "s/shadow = .*/shadow = ${P_SHADOWS};/" \
		-e "s/shadow-color = .*/shadow-color = \"${SHADOW_C}\"/" \
		-e "s/fading = .*/fading = ${P_FADE};/" \
		-e "s/corner-radius = .*/corner-radius = ${P_CORNER_R}/"

	# Cambiar opacidad para ventanas inactivas
	sed -i "$picom_rules_file" \
		-e "s/opacity = .*/opacity = 1;/"

	# Añadir regla para cambiar la opacidad de aplicaciones inactivas
	sed -i "$picom_rules_file" \
		-e '/# Inactive windows opacity/a\opacity = 0.75;' \
		-e '/# Exclude polybar from transparency/a\window_type = "dock" opacity = 1;'

	# Si las animaciones están habilitadas
	if [[ "$ANIMATIONS" = "true" ]]; then
		sed -i "$picom_rules_file" \
			-e '/picom-animations/c\@include "picom-animations.conf"'
	else
		sed -i "$picom_rules_file" \
			-e '/picom-animations/c\#@include "picom-animations.conf"'
	fi
}

# Set dunst config
set_dunst_config() {
	dunst_config_file="$HOME/.config/bspwm/src/config/dunstrc"

	sed -i "$dunst_config_file" \
		-e "s/transparency = .*/transparency = 0/g" \
		-e "s/icon_theme = .*/icon_theme = \"${gtk_icons}, Adwaita\"/g" \
		-e "s/frame_color = .*/frame_color = \"${bg}\"/g" \
		-e "s/separator_color = .*/separator_color = \"${magenta}\"/g" \
		-e "s/font = .*/font = JetBrainsMono NF Medium 9/g" \
		-e "s/foreground='.*'/foreground='${blue}'/g"

	sed -i '/urgency_low/Q' "$dunst_config_file"
	cat >>"$dunst_config_file" <<-_EOF_
		[urgency_low]
		timeout = 3
		background = "${bg}"
		foreground = "${green}"

		[urgency_normal]
		timeout = 5
		background = "${bg}"
		foreground = "${white}"

		[urgency_critical]
		timeout = 0
		background = "${bg}"
		foreground = "${red}"
	_EOF_
}

# Set eww colors
set_eww_colors() {
	cat >"$HOME"/.config/bspwm/eww/colors.scss <<EOF
\$bg: ${bg};
\$bg-alt: #222330;
\$fg: ${fg};
\$black: ${blackb};
\$red: ${red};
\$green: ${green};
\$yellow: ${yellow};
\$blue: ${blue};
\$magenta: ${magenta};
\$cyan: ${cyan};
\$archicon: #0f94d2;
EOF
}

set_launchers() {
	# Jgmenu
	sed -i "$HOME"/.config/bspwm/src/config/jgmenurc \
		-e "s/color_menu_bg = .*/color_menu_bg = ${bg}/" \
		-e "s/color_norm_fg = .*/color_norm_fg = ${fg}/" \
		-e "s/color_sel_bg = .*/color_sel_bg = #222330/" \
		-e "s/color_sel_fg = .*/color_sel_fg = ${fg}/" \
		-e "s/color_sep_fg = .*/color_sep_fg = ${blackb}/"

	# Rofi launchers
	cat >"$HOME"/.config/bspwm/src/rofi-themes/shared.rasi <<EOF
// Rofi colors

* {
    font: "JetBrainsMono NF Bold 9";
    background: ${bg};
    bg-alt: #222330;
    background-alt: ${bg}E0;
    foreground: ${fg};
    selected: ${blue};
    active: ${green};
    urgent: ${red};
}
EOF

	# Screenlock colors
	sed -i "$HOME"/.config/bspwm/src/ScreenLocker \
		-e "s/bg=.*/bg=${bg:1}/" \
		-e "s/fg=.*/fg=${fg:1}/" \
		-e "s/ring=.*/ring=${black:1}/" \
		-e "s/wrong=.*/wrong=${red:1}/" \
		-e "s/date=.*/date=${fg:1}/" \
		-e "s/verify=.*/verify=${green:1}/"
}

set_appearance() {
    # Verificar si xsettingsd está corriendo
    if pidof -q xsettingsd; then
        # Si xsettingsd está corriendo, editamos el archivo de configuración de xsettingsd
        echo "xsettingsd is running. Updating configuration..."
        # Verificar si el archivo de configuración de xsettingsd existe
        if [ ! -f "$HOME/.config/bspwm/src/config/xsettingsd" ]; then
            echo "Creating xsettingsd config..."
            mkdir -p "$HOME/.config/bspwm/src/config"
            echo -e "Net/ThemeName \"$gtk_theme\"\nNet/IconThemeName \"$gtk_icons\"\nGtk/CursorThemeName \"$gtk_cursor\"" > "$HOME/.config/bspwm/src/config/xsettingsd"
        else
            # Si el archivo existe, lo actualizamos con los nuevos valores
            sed -i "$HOME/.config/bspwm/src/config/xsettingsd" \
                -e "s|Net/ThemeName .*|Net/ThemeName \"$gtk_theme\"|" \
                -e "s|Net/IconThemeName .*|Net/IconThemeName \"$gtk_icons\"|" \
                -e "s|Gtk/CursorThemeName .*|Gtk/CursorThemeName \"$gtk_cursor\"|"
        fi
    else
        # Si xsettingsd no está corriendo, intentar modificar gtk-3.0/settings.ini
        echo "xsettingsd is not running. Updating GTK3 settings..."

        # Verificar si el archivo settings.ini existe
        if [ ! -f "$HOME/.config/gtk-3.0/settings.ini" ]; then
            echo "Creating GTK3 settings.ini..."
            mkdir -p "$HOME/.config/gtk-3.0"
            echo -e "[Settings]\ngtk-theme-name=$gtk_theme\ngtk-icon-theme-name=$gtk_icons\ngtk-cursor-theme-name=$gtk_cursor" > "$HOME/.config/gtk-3.0/settings.ini"
        else
            # Si el archivo settings.ini existe, lo actualizamos con los nuevos valores
            sed -i "$HOME/.config/gtk-3.0/settings.ini" \
                -e "s/gtk-theme-name=.*/gtk-theme-name=$gtk_theme/" \
                -e "s/gtk-icon-theme-name=.*/gtk-icon-theme-name=$gtk_icons/" \
                -e "s/gtk-cursor-theme-name=.*/gtk-cursor-theme-name=$gtk_cursor/"
        fi

        # Verificar si el archivo .gtkrc-2.0 existe y crearlo si es necesario
        if [ ! -f "$HOME/.gtkrc-2.0" ]; then
            echo "Creating .gtkrc-2.0..."
            echo -e "gtk-theme-name=\"$gtk_theme\"\ngtk-icon-theme-name=\"$gtk_icons\"\ngtk-cursor-theme-name=\"$gtk_cursor\"" > "$HOME/.gtkrc-2.0"
        else
            # Si el archivo .gtkrc-2.0 existe, lo actualizamos
            sed -i "$HOME/.gtkrc-2.0" \
                -e "s/gtk-theme-name=.*/gtk-theme-name=\"$gtk_theme\"/" \
                -e "s/gtk-icon-theme-name=.*/gtk-icon-theme-name=\"$gtk_icons\"/" \
                -e "s/gtk-cursor-theme-name=.*/gtk-cursor-theme-name=\"$gtk_cursor\"/"
        fi
    fi

    # Actualizar el tema de cursores
    sed -i -e "s/Inherits=.*/Inherits=$gtk_cursor/" "$HOME/.icons/catppuccin-mocha-dark-cursors/index.theme"

    # Recargar la configuración de xsettingsd si está corriendo
    if pidof -q xsettingsd; then
        killall -HUP xsettingsd
    fi

    # Aplicar el cursor
    xsetroot -cursor_name left_ptr

    echo "Appearance settings applied successfully."
}

# Launch theme
launch_theme() {

	# Launch dunst notification daemon
	dunst -config "${HOME}"/.config/bspwm/src/config/dunstrc &

	# Launch polybar
	sleep 0.1
	for mon in $(polybar --list-monitors | cut -d":" -f1); do
		MONITOR=$mon polybar -q top-bar -c "${HOME}"/.config/bspwm/Theme/config.ini &
	done
}

### Apply Configurations

set_bspwm_config
set_picom_config
set_dunst_config
set_eww_colors
set_launchers
set_appearance
launch_theme
