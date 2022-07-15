username=$(whoami)
currentDir=$(pwd)

# use Cloudflare DNS
if [[ -f "resolv.conf" ]]
then
    echo "updating DNS"
    sudo cp "$currentDir"/resolv.conf /etc/resolv.conf
fi


echo "Updating packages"
sudo pacman -Syy


# Install yay
# --------------------------------------------
echo "Installing yay"
sudo pacman -S --needed base-devel --noconfirm
sudo pacman -S git --noconfirm
cd /opt
sudo rm -rf yay-git
sudo git clone --quiet https://aur.archlinux.org/yay-git.git
sudo chown -R $username:$username ./yay-git
cd yay-git
echo "running installer"
makepkg -si --noconfirm
yay -Syu
echo "Installed yay"
# --------------------------------------------


# Install brave
# --------------------------------------------
echo "Installing Brave"
yay -S aur/brave-bin --noconfirm
echo "Installed Brave"
# --------------------------------------------


# Install ZSH
# --------------------------------------------
echo "Installing zsh"
yay -S zsh --noconfirm

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended # install oh-my-zsh
echo "getting zsh theme"
git clone --quiet --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k > /dev/null
echo "getting zsh autosuggestions"
git clone --quiet https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions > /dev/null
echo "getting zsh highlighting"
git clone --quiet https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting > /dev/null
# --------------------------------------------


# Install my setup scripts
echo "Installing scripts"
# --------------------------------------------
cd $currentDir
echo "getting gg-dev-05's scripts and dotfiles"
echo ".dotfiles"
git clone --quiet https://github.com/gg-dev-05/.dotfiles.git > /dev/null
echo "scripts"
git clone --quiet https://github.com/gg-dev-05/scripts.git > /dev/null
echo "installer"
git clone --quiet https://github.com/gg-dev-05/installer.git > /dev/null
cp "$currentDir"/.dotfiles/zsh/.zshrc ~/
cp "$currentDir"/.dotfiles/zsh/.p10k.zsh ~/
echo "zsh theming done"
cp -r "$currentDir"/installer/.local ~/
cp -r "$currentDir"/installer/.config ~/
echo "Shortcuts and themes added"
# --------------------------------------------


# Install Blueman
# --------------------------------------------
echo "Setting Bluetooth"
yay -S blueman --noconfirm
yay -S bluez --noconfirm
yay -S bluez-utils --noconfirm 
yay -Syyuu bluedevil bluez-utils pulseaudio-bluetooth --noconfirm
sudo systemctl start bluetooth.service
sudo systemctl enable bluetooth.service
echo "Bluetooth setup done"
# --------------------------------------------


# Install vs code
echo "Installing vscode"
yay -S visual-studio-code-bin --noconfirm > /dev/null
echo "Installed vscode"

# Change default shell
# echo "change your default shell by running:"
# echo "chsh -s $(which zsh)"
chsh -s $(which zsh)
echo "Rebooting :)"
sleep 5
sudo reboot now
