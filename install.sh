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

if [ -d ".config" ]; then
    cd .config
    
    for dir in */; do
        dirname="${dir%/}"
        echo -e "${BLUE}Installing: $dirname${NC}"
        stow "$dirname"
    done
    
    cd ..
fi

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
        # Install regular packages via pacman
        echo -e "${BLUE}Installing core packages...${NC}"
        sudo pacman -S --needed --noconfirm \
            hyprland kitty waybar wofi hyprlock hypridle mako \
            grim slurp wl-clipboard fastfetch swaybg
        
        # Check for AUR helper
        AUR_HELPER=""
        if command -v yay &> /dev/null; then
            AUR_HELPER="yay"
            echo -e "${GREEN}Found yay${NC}"
        elif command -v paru &> /dev/null; then
            AUR_HELPER="paru"
            echo -e "${GREEN}Found paru${NC}"
        else
            echo -e "${YELLOW}No AUR helper found. Installing paru...${NC}"
            
            # Install dependencies for paru
            sudo pacman -S --needed --noconfirm base-devel git
            
            # Clone and install paru
            cd /tmp
            git clone https://aur.archlinux.org/paru.git
            cd paru
            makepkg -si --noconfirm
            cd ~
            rm -rf /tmp/paru
            
            AUR_HELPER="paru"
            echo -e "${GREEN}paru installed successfully${NC}"
        fi
        
        # Install AUR packages
        echo -e "${BLUE}Installing AUR packages...${NC}"
        $AUR_HELPER -S --needed --noconfirm \
            papirus-icon-theme whitesur-gtk-theme whitesur-cursor-theme
        
        echo -e "${GREEN}All packages installed!${NC}"
    elif command -v apt &> /dev/null; then
        sudo apt install -y hyprland kitty waybar wofi hyprlock mako grim slurp wl-clipboard fastfetch
    fi
fi

# === DONE ===
echo -e "\n${GREEN}=== Installation complete! ===${NC}"
echo -e "${BLUE}Restart your session or run:${NC}"
echo -e "  hyprctl reload"
echo -e "  pkill waybar && waybar &"
echo -e "  pkill mako && mako &"
