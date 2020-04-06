#!/bin/bash

#set -e

spatialPrint() {
	tput sc
	tput bold
	echo -e $STATUS
	echo -e "\n================================================\n"
	echo -e "$*\n"
	tput sgr0
}

# To note: the execute() function doesn't handle pipes well
execute () {
	spatialPrint $*
	$@
	
	if [ $? -eq 0 ]
	then
		tput rc
		tput ed
	else
		tput bold
		echo -e "\nFailed to Execute $*" >&2
		exit 1
	fi
}

echo ""

STATUS="Updating packages, installing restricted-extras and removing unnecessary packages"

#execute sudo apt update -y
#execute sudo apt dist-upgrade -y
#execute sudo apt install ubuntu-restricted-extras -y
#execute sudo apt autoremove -y
#sudo add-apt-repository "deb http://archive.canonical.com/ubuntu $(lsb_release -sc) partner"

STATUS="Installing essential terminal applications and packages (git,wget,curl,tilda,tmux,xclip,vim,micro)"

#execute sudo apt install git wget curl -y
#execute sudo apt install terminator -y
#execute sudo apt install xclip -y
#execute sudo apt install vim-gui-common vim-runtime -y
#execute sudo snap install micro --classic

#cp ./config_files/vimrc ~/.vimrc
#mkdir -p ~/.config/micro/
#cp ./config_files/micro_bindings.json ~/.config/micro/bindings.json

# refer : [http://www.rushiagr.com/blog/2016/06/16/everything-you-need-to-know-about-tmux-copy-pasting-ubuntu/] for tmux buffers in ubuntu
#cp ./config_files/tmux.conf ~/.tmux.conf
#cp ./config_files/tmux.conf.local ~/.tmux.conf.local
#mkdir -p ~/.config/tilda
#cp ./config_files/config_0 ~/.config/tilda/


#Checks if ZSH is partially or completely Installed to Remove the folders and reinstall it
rm -rf ~/.z*
zsh_folder=/opt/.zsh/
if [[ -d $zsh_folder ]];then
	sudo rm -r /opt/.zsh/*
fi

execute sudo apt-get install zsh -y

sudo mkdir -p /opt/.zsh/ && sudo chmod ugo+w /opt/.zsh/
export ZIM_HOME=/opt/.zsh/zim
curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh
# Change default shell to zsh
command -v zsh | sudo tee -a /etc/shells
sudo chsh -s "$(command -v zsh)" "${USER}"

{
    echo "if [ -f ~/.bash_aliases ]; then"
    echo "  source ~/.bash_aliases"
    echo "fi"

    echo "# Switching to 256-bit colour by default so that zsh-autosuggestion's suggestions are not suggested in white, but in grey instead"
    echo "export TERM=xterm-256color"

    echo "# Setting the default text editor to micro, a terminal text editor with shortcuts similar to what you'd encounter in an IDE"
    echo "export VISUAL=micro"
} >> ~/.zshrc


# For utilities such as lspci
execute sudo apt-get install pciutils

## Detect if an Nvidia card is attached, and install the graphics drivers automatically
if [[ -n $(lspci | grep -i nvidia) ]]; then
    spatialPrint "Installing Display drivers and any other auto-detected drivers for your hardware"
    execute sudo add-apt-repository ppa:graphics-drivers/ppa -y
    execute sudo apt-get update
    execute sudo ubuntu-drivers autoinstall
fi

spatialPrint "The script has finished."

