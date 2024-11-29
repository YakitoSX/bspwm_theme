#!/usr/bin/env bash
#  ╔═╗╦═╗╔═╗╦ ╦  ╦ ╦╔═╗╔╦╗╔═╗╔╦╗╔═╗╔═╗
#  ╠═╣╠╦╝║  ╠═╣  ║ ║╠═╝ ║║╠═╣ ║ ║╣ ╚═╗
#  ╩ ╩╩╚═╚═╝╩ ╩  ╚═╝╩  ═╩╝╩ ╩ ╩ ╚═╝╚═╝
# Script to check for new updates in arch and AUR(paru, yay).

# Check if yay is installed
check_yay_installed() {
    command -v yay >/dev/null 2>&1
}

# Check if paru is installed
check_paru_installed() {
    command -v paru >/dev/null 2>&1
}

# Get the total number of updates available (official + AUR)
get_total_updates() {
    local total_updates

    # Get updates from official repositories (checkupdates)
    local official_updates=$(checkupdates 2> /dev/null | wc -l || echo 0)

    # Get updates from AUR (paru and yay)
    local aur_updates=0
    if check_paru_installed; then
        aur_updates=$((aur_updates + $(paru -Qua 2> /dev/null | wc -l || echo 0)))
    fi
    if check_yay_installed; then
        aur_updates=$((aur_updates + $(yay -Qua 2> /dev/null | wc -l || echo 0)))
    fi

    # Sum the total updates (official + AUR)
    total_updates=$((official_updates + aur_updates))

    echo "${total_updates:-0}"
}

# Print the list of updates available from official repositories
get_list_updates() {
    echo -e "\033[1m\033[34mRegular updates:\033[0m"
    checkupdates | sed 's/->/\x1b[32;1m\x1b[0m/g'
}

# Print the list of updates available from AUR
get_list_aur_updates() {
    local aur_updates=""
    
    if check_paru_installed; then
        aur_updates=$(paru -Qua)
    fi
    if check_yay_installed; then
        aur_updates="$aur_updates$(yay -Qua)"
    fi

    if [[ -n "$aur_updates" ]]; then
        echo -e "\n\033[1m\033[34mAur updates available:\033[0m"
        echo "$aur_updates" | sed 's/->/\x1b[32;1m\x1b[0m/g'
    fi
}

# Print available updates or a message if no updates are found
print_updates() {
    local print_updates
    print_updates=$(get_total_updates)

    if [[ "$print_updates" -gt 0 ]]; then
        echo -e "\033[1m\033[33mThere are $print_updates updates available:\033[0m\n"
        get_list_updates
        get_list_aur_updates
    else
        echo -e "\033[1m\033[32mYour system is already updated!\033[0m"
    fi
}

# Update the system (official repos + AUR)
update_system() {
    # First update official repositories with pacman
    echo -e "\033[1m\033[33mUpdating official repositories...\033[0m"
    sudo pacman -Syu --noconfirm

    # If paru is installed, update AUR packages
    if check_paru_installed; then
        echo -e "\033[1m\033[33mUpdating AUR packages with paru...\033[0m"
        paru -Syu --noconfirm
    fi
    # If yay is installed, update AUR packages
    if check_yay_installed; then
        echo -e "\033[1m\033[33mUpdating AUR packages with yay...\033[0m"
        yay -Syu --noconfirm
    fi
}

# Case statement to handle different options
case "$1" in
    --get-updates) get_total_updates ;;  # Get the number of updates available
    --print-updates) print_updates ;;  # Print the list of updates available
    --update-system) update_system ;;  # Update the system (official + AUR)
    --help|*) echo -e "Updates [options]

Options:
    --get-updates       Get the number of updates available.
    --print-updates     Print the list of available packages to update.
    --update-system     Update your system including the AUR packages.\n"
esac