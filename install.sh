#!/bin/bash

# === COLORS ===
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# === CHECKS ===
echo -e "${BLUE}=== Installing dotfiles ===${NC}"

# Check if script is run from dotfiles directory
if [ ! -f "install.sh" ]; then
    echo -e "${RED}Error: please run this script from the dotfiles directory${NC}"
    exit 1
fi

# Check for GNU Stow
if ! command -v stow &> /dev/null; then
    echo -e "${YELLOW}GNU Stow not found. Installing...${NC}"
    if command -v pacman &> /dev/null; then
        sudo pacman -S stow --noconfirm
    elif command -v apt &> /dev/null; then
        sudo apt install stow -y
    elif command -v dnf &> /dev/null; then
        sudo dnf install stow -y
    else
        echo -e "${RED}Failed to install stow. Please install it manually.${NC}"
        exit 1
    fi
fi

# === INSTALL CONFIGS WITH STOW ===
echo -e "\n${GREEN}=== Installing configs ===${NC}"

# Install from .config directory
if [ -d ".config" ]; then
    cd .config
    
    # Stow each config directory
    for dir in */; do
        dirname="${dir%/}"
        echo -e "${BLUE}Installing: $dirname${NC}"
        stow "$dirname"
    done
    
    cd ..
fi

# Install .local/bin
if [ -d ".local/bin" ]; then
    echo -e "${BLUE}Installing: .local/bin${NC}"
    stow .local
fi

# === INSTALL WALLPAPERS AND IMAGES ===
echo -e "\n${GREEN}=== Installing wallpapers and images ===${NC}"

if [ -d "Pictures/wallpapers" ]; then
    mkdir -p ~/Pictures/wallpapers
    cp -r Pictures/wallpapers/* ~/Pictures/wallpapers/ 2>/dev/null
    echo -e "${BLUE}Wallpapers installed${NC}"
fi

if [ -d "Pictures/Terminal_Images" ]; then
    mkdir -p ~/Pictures/Terminal_Images
    cp -r Pictures/Terminal_Images/* ~/Pictures/Terminal_Images/ 2>/dev/null
    echo -e "${BLUE}Fastfetch images installed${NC}"
fi

# === SET SCRIPT PERMISSIONS ===
echo -e "\n${GREEN}=== Setting permissions ===${NC}"
chmod +x ~/.local/bin/screenshot-* 2>/dev/null
echo -e "${BLUE}Screenshot scripts ready${NC}"

# === INSTALL PACKAGES (OPTIONAL) ===
echo -e "\n${YELLOW}Do you want to install required packages? (y/n)${NC}"
read -r install_packages

if [[ "$install_packages" =~ ^[Yy]$ ]]; then
    echo -e "${BLUE}Installing packages...${NC}"
    
    if command -v pacman &> /dev/null; then
        sudo pacman -S --needed --noconfirm hyprland kitty waybar wofi hyprlock hypridle mako grim slurp wl-clipboard fastfetch swaybg papirus-icon-theme whitesur-gtk-theme whitesur-cursor-theme
    elif command -v apt &> /dev/null; then
        sudo apt install -y hyprland kitty waybar wofi hyprlock mako grim slurp wl-clipboard fastfetch
    fi
    
    echo -e "${GREEN}Packages installed!${NC}"
fi

# === DONE ===
echo -e "\n${GREEN}=== Installation complete! ===${NC}"
echo -e "${BLUE}Restart your session or run:${NC}"
echo -e "  hyprctl reload"
echo -e "  pkill waybar && waybar &"
echo -e "  pkill mako && mako &"
