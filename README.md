# 🎨 Hyprland Dotfiles

My Hyprland configuration with monochrome theme, animations, and blur.

![Preview](https://img.shields.io/badge/WM-Hyprland-blue?style=for-the-badge)
![OS](https://img.shields.io/badge/OS-Arch_Linux-1793d1?style=for-the-badge&logo=arch-linux)
![Wayland](https://img.shields.io/badge/Protocol-Wayland-ff6b6b?style=for-the-badge)

---

## 📸 Screenshots

<details>
<summary><b>Click to view screenshots</b></summary>
<img width="1920" height="1080" alt="2026-06-06_02-10-36" src="https://github.com/user-attachments/assets/649a6f58-35a5-4e2b-9e33-fa8999ba932e" />
<img width="1920" height="1080" alt="2026-06-06_13-01-43" src="https://github.com/user-attachments/assets/32047ffb-760a-4b03-b4f6-c1a112c15027" />
<img width="1920" height="1080" alt="2026-06-06_02-04-30" src="https://github.com/user-attachments/assets/87c802ee-3430-4eba-9dbc-fdbb462c5b5c" />


</details>

---

## ✨ Features

- 🎭 **Monochrome theme** — Minimalist black and white style
- 🖼️ **Blur & transparency** — Blur and transparency everywhere
- ⚡ **Animations** — Smooth window and workspace animations
- 🎨 **Custom fastfetch** — System info with PNG images
- 🔔 **Notifications** — Beautiful notifications via Mako
- 📸 **Screenshots** — Convenient keybindings for screenshots
- 🔒 **Lock screen** — Stylish lock screen with blur

---

## 📦 What's Inside

| Component | Description |
|-----------|-------------|
| **Hyprland** | Wayland compositor with animations |
| **Waybar** | Custom bar with monochrome style |
| **Kitty** | Terminal with 85% transparency |
| **Wofi** | Application launcher |
| **Hyprlock** | Lock screen with blur |
| **Mako** | Notifications daemon |
| **Fastfetch** | System information |
| **Grim + Slurp** | Screenshot utilities |
| **Swaybg** | Wallpaper setter |

---

## 🚀 Installation

### Quick Install

```bash
# Clone the repository
git clone https://github.com/DanyaTorvalds/dotfiles.git
cd dotfiles

# Run the installer
./install.sh
```


# Manual Installation
## Install GNU Stow
```bash
sudo pacman -S stow
# Install configs
stow .config/hypr
stow .config/waybar
stow .config/kitty
stow .config/wofi
stow .config/mako
stow .config/fastfetch
stow .config/hyprlock
stow .local/bin
```
## Copy wallpapers and images
```bash
cp -r Pictures/* ~/Pictures/
```
## Install Packages
```bash
sudo pacman -S hyprland kitty waybar wofi hyprlock hypridle mako grim slurp wl-clipboard fastfetch swaybg papirus-icon-theme whitesur-gtk-theme whitesur-cursor-theme
```
# ⌨️ Keybindings
| Keys | Action |
|-----------|-------------|
| **Win + Enter** | Open terminal (Kitty) |
| **Win + Space** | Application menu (Wofi) |
| **Win + Q** | Close active window |
| **Win + M** | Restart Hyprland |
| **Win + V** | Toggle floating window |
| **Win + ←/→/↑/↓** | Move focus between windows |
| **Win + 1-4** | Switch workspaces |
| **Win + Shift + 1-4** | Move window to workspace |
| **PrintScreen** | Screenshot full screen |
| **Win + Shift + S** | Screenshot area (to clipboard) |
