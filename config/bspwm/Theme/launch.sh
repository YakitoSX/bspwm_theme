#!/usr/bin/env bash

# Vars config
# Bspwm border		# Normal border color	# Focused border color
BORDER_WIDTH="0"	NORMAL_BC="#414868"		FOCUSED_BC="#bb9af7"


# (Tokyo Night) colorscheme
bg="#1a1b26"  fg="#c0caf5"

black="#15161e"   red="#f7768e"   green="#9ece6a"   yellow="#e0af68"
blackb="#414868"  redb="#f7768e"  greenb="#9ece6a"  yellowb="#e0af68"

blue="#7aa2f7"   magenta="#bb9af7"   cyan="#7dcfff"   white="#a9b1d6"
blueb="#7aa2f7"  magentab="#bb9af7"  cyanb="#7dcfff"  whiteb="#c0caf5"

# Gtk theme vars
gtk_theme="TokyoNight-zk"	gtk_icons="Papirus-Dark"

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
	cat >"$HOME"/.config/eww/colors.scss <<EOF
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
set_eww_colors
set_launchers
launch_theme
