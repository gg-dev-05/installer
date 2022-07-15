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
sudo pacman -S --needed base-devel --noconfirm > /dev/null
sudo pacman -S git --noconfirm > /dev/null
cd /opt
sudo rm -rf yay-git
sudo git clone --quiet https://aur.archlinux.org/yay-git.git > /dev/null
sudo chown -R $username:$username ./yay-git
cd yay-git
echo "running installer"
{
    makepkg -si --noconfirm > /dev/null
    sudo yay -Syu > /dev/null
} &> /dev/null
echo "Installed yay"
# --------------------------------------------


# Install brave
# --------------------------------------------
echo "Installing Brave"
yay -S aur/brave-bin --noconfirm > /dev/null
echo "Installed Brave"
# --------------------------------------------


# Install ZSH
# --------------------------------------------
echo "Installing zsh"
yay -S zsh --noconfirm > /dev/null
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
git clone --quiet https://github.com/gg-dev-05/.dotfiles.git > /dev/null
git clone --quiet https://github.com/gg-dev-05/scripts.git > /dev/null
cp "$currentDir"/.dotfiles/zsh/.zshrc ~/
cp "$currentDir"/.dotfiles/zsh/.p10k.zsh ~/
echo "zsh theming done"
# --------------------------------------------


# Install vs code
echo "Installing vscode"
yay -S visual-studio-code-bin --noconfirm > /dev/null
echo "Installed vscode"

# Change default shell
echo "change your default shell by running:"
echo "chsh -s $(which zsh)"
echo "BYE."
