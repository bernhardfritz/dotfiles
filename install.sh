#!/usr/bin/env bash

set -e

cd "$(dirname "$0")"

# Confirm
read -p "Are you sure? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  exit 1
fi

# Install packages
readarray -t packages < packages.txt
sudo apt-get update
sudo apt-get -y install "${packages[@]}"

# Stow
for directory in */; do
  stow "$directory"
done

# oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Wallpaper
cp path-of-exile-beach-arrival.jpg ~/.config/background

# Install gnome extensions
pipx install gnome-extensions-cli --system-site-packages
readarray -t extensions < extensions.txt
for extension in "${extensions[@]}"; do
  ~/.local/bin/gext install "$extension"
done

# Load gnome settings
dconf load /org/gnome/ < org.gnome.dconf

# Install snaps
readarray -t snaps < snaps.txt
sudo snap install "${snaps[@]}"

# Set ghostty as default
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /snap/ghostty/current/bin/ghostty 50
sudo update-alternatives --set x-terminal-emulator /snap/ghostty/current/bin/ghostty

# Install fonts
wget -O ~/.local/share/fonts/MesloLGS\ NF\ Regular.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
wget -O ~/.local/share/fonts/MesloLGS\ NF\ Bold.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
wget -O ~/.local/share/fonts/MesloLGS\ NF\ Italic.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
wget -O ~/.local/share/fonts/MesloLGS\ NF\ Bold\ Italic.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
fc-cache -f -v