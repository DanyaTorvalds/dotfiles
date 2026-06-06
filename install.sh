#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Installing dotfiles ===${NC}"

if [ ! -f "install.sh" ]; then
    echo -e "${RED}Error: please run this script from the dotfiles directory${NC}"
    exit 1
fi

if ! command -v stow &> /dev/null; then
    echo -e "${YELLOW}GNU Stow not found. Installing...${NC}"
    if command -v pacman &> /dev/null; then
        sudo pacman -S stow
    elif command -v apt &> /dev/null; then
        sudo apt install stow
    elif command -v dnf &> /dev/null; then
        sudo dnf install stow
    else
        echo -e "${RED}Failed to install stow. Please install it manually.${NC}"
        exit 1
    fi
fi

echo -e "\n${GREEN}=== Installing configs ===${NC}"

PACKAGES=(
    ".config/hypr"
    ".config/waybar"
    ".config/kitty"
    ".config/wofi"
    ".config/mako"
    ".config/fastfetch"
    ".config/hyprlock"
    ".local/bin"
)

for pkg in "${PACKAGES[@]}"; do
    if [ -d "$pkg" ]; then
        echo -e "${BLUE}Installing: $pkg${NC}"
        stow "$pkg"
    else
        echo -e "${YELLOW}Skipping: $pkg (not found)${NC}"
    fi
done

echo -e "\n${GREEN}=== Installing wallpapers and images ===${NC}"

if [ -d "Pictures/wallpapers" ]; then
    mkdir -p ~/Pictures/wallpapers
    cp -r Pictures/wallpapers/* ~/Pictures/wallpapers/
    echo -e "${BLUE}Wallpapers installed${NC}"
fi

if [ -d "Pictures/Terminal_Images" ]; then
    mkdir -p ~/Pictures/Terminal_Images
    cp -r Pictures/Terminal_Images/* ~/Pictures/Terminal_Images/
    echo -e "${BLUE}Fastfetch images installed${NC}"
fi

echo -e "\n${GREEN}=== Setting permissions ===${NC}"
chmod +x ~/.local/bin/screenshot-* 2>/dev/null
echo -e "${BLUE}Screenshot scripts ready${NC}"

echo -e "\n${YELLOW}Do you want to install required packages? (y/n)${NC}"
read -r install_packages

if [[ "$install_packages" =~ ^[Yy]$ ]]; then
    echo -e "${BLUE}Installing packages...${NC}"
    
    if command -v pacman &> /dev/null; then
        sudo pacman -S --needed hyprland kitty waybar wofi hyprlock hypridle mako grim slurp wl-clipboard fastfetch swaybg papirus-icon-theme whitesur-gtk-theme whitesur-cursor-theme
    elif command -v apt &> /dev/null; then
        sudo apt install hyprland kitty waybar wofi hyprlock mako grim slurp wl-clipboard fastfetch
    fi
    
    echo -e "${GREEN}Packages installed!${NC}"
fi

echo -e "\n${GREEN}=== Installation complete! ===${NC}"
echo -e "${BLUE}Restart your session or run:${NC}"
echo -e "  hyprctl reload"
echo -e "  pkill waybar && waybar &"
echo -e "  pkill mako && mako &"
