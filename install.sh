#!/bin/bash


RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Установка dotfiles ===${NC}"

if [ ! -f "install.sh" ]; then
    echo -e "${RED}Ошибка: запусти скрипт из папки dotfiles${NC}"
    exit 1
fi

if ! command -v stow &> /dev/null; then
    echo -e "${YELLOW}GNU Stow не установлен. Устанавливаю...${NC}"
    if command -v pacman &> /dev/null; then
        sudo pacman -S stow
    elif command -v apt &> /dev/null; then
        sudo apt install stow
    elif command -v dnf &> /dev/null; then
        sudo dnf install stow
    else
        echo -e "${RED}Не удалось установить stow. Установи вручную.${NC}"
        exit 1
    fi
fi

echo -e "\n${GREEN}=== Установка конфигов ===${NC}"

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
        echo -e "${BLUE}Устанавливаю: $pkg${NC}"
        stow "$pkg"
    else
        echo -e "${YELLOW}Пропускаю: $pkg (не найдено)${NC}"
    fi
done

echo -e "\n${GREEN}=== Установка обоев и картинок ===${NC}"

if [ -d "Pictures/wallpapers" ]; then
    mkdir -p ~/Pictures/wallpapers
    cp -r Pictures/wallpapers/* ~/Pictures/wallpapers/
    echo -e "${BLUE}Обои установлены${NC}"
fi

if [ -d "Pictures/Terminal_Images" ]; then
    mkdir -p ~/Pictures/Terminal_Images
    cp -r Pictures/Terminal_Images/* ~/Pictures/Terminal_Images/
    echo -e "${BLUE}Картинки для fastfetch установлены${NC}"
fi

echo -e "\n${GREEN}=== Настройка прав ===${NC}"
chmod +x ~/.local/bin/screenshot-* 2>/dev/null
echo -e "${BLUE}Скрипты скриншотов готовы${NC}"

echo -e "\n${YELLOW}Хочешь установить необходимые пакеты? (y/n)${NC}"
read -r install_packages

if [[ "$install_packages" =~ ^[Yy]$ ]]; then
    echo -e "${BLUE}Устанавливаю пакеты...${NC}"
    
    if command -v pacman &> /dev/null; then
        sudo pacman -S --needed hyprland kitty waybar wofi hyprpaper hyprlock hypridle mako grim slurp wl-clipboard fastfetch swaybg papirus-icon-theme whitesur-gtk-theme whitesur-cursor-theme
    elif command -v apt &> /dev/null; then
        sudo apt install hyprland kitty waybar wofi hyprlock mako grim slurp wl-clipboard fastfetch
    fi
    
    echo -e "${GREEN}Пакеты установлены!${NC}"
fi

echo -e "\n${GREEN}=== Установка завершена! ===${NC}"
echo -e "${BLUE}Перезапусти сессию или выполни:${NC}"
echo -e "  hyprctl reload"
echo -e "  pkill waybar && waybar &"
echo -e "  pkill mako && mako &"
