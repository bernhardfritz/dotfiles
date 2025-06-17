#!/usr/bin/env bash

set -e

cd "$(dirname "$0")"

# Confirm ubuntu debullshit (https://github.com/polkaulfield/ubuntu-debullshit)
read -p "Did you already debullshitify ubuntu? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  exit 1
fi

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

# Add Docker's official GPG key:
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install extra packages
readarray -t extraPackages < extra-packages.txt
sudo apt-get update
sudo apt-get -y install "${extraPackages[@]}"

# Manage Docker as a non-root user
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

# oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
# Install fonts
wget -O ~/.local/share/fonts/MesloLGS\ NF\ Regular.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
wget -O ~/.local/share/fonts/MesloLGS\ NF\ Bold.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
wget -O ~/.local/share/fonts/MesloLGS\ NF\ Italic.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
wget -O ~/.local/share/fonts/MesloLGS\ NF\ Bold\ Italic.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
fc-cache -f -v
# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# Make zsh default
chsh -s $(which zsh)

# Stow
for directory in */; do
  stow "$directory"
done

# Install gnome extensions
pipx install gnome-extensions-cli --system-site-packages
readarray -t gnome_extensions < gnome-extensions.txt
for gnome_extension in "${gnome_extensions[@]}"; do
  ~/.local/bin/gext install "$gnome_extension"
done

# Load gnome settings
dconf load /org/gnome/ < org.gnome.dconf

# Install flatpaks
readarray -t flatpaks < flatpaks.txt
for pak in "${flatpaks[@]}"; do
  sudo flatpak install flathub "$pak"
done
flatpak override --user --filesystem=/run/docker.sock com.visualstudio.code

# Install vscode extensions
readarray -t vscode_extensions < vscode-extensions.txt
for vscode_extension in "${vscode_extensions[@]}"; do
  code --install-extension "$vscode_extension"
done

# Download and extract neovim appimage for use in flatpak'ed vscode extension asvetliakov.vscode-neovim
# NOTE: This step will be obsolete once ubuntu package repository provides a neovim version greater than 0.10.0
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
chmod u+x nvim-linux-x86_64.appimage
./nvim-linux-x86_64.appimage --appimage-extract
sudo mv ./squashfs-root ~/.var/app/com.visualstudio.code/data/nvim-linux-x86_64.appimage
rm ./nvim-linux-x86_64.appimage