#!/bin/sh
set -eux

# =========================================================================================================
# Update the apt package list.
# =========================================================================================================
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y build-essential curl file git software-properties-common pkg-config libssl-dev

# =========================================================================================================
# Install : zsh, oh-my-zsh
# =========================================================================================================
sudo apt-get install -y zsh
# restart your console
chsh -s $(which zsh)
# restart your console
echo $SHELL

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# =========================================================================================================
# Install : rust & companions :)
# =========================================================================================================
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
. $HOME/.cargo/env

cargo install bat
cargo install broot
cargo install clog ??? FIXME
cargo install dust ??? FIXME
cargo install watchexec

cargo install exa
echo "alias ll='exa -la'" >> ~/.zshrc
echo "alias ls='exa'" >> ~/.zshrc

cargo install fd-find
echo "alias fd=fdfind" >> ~/.zshrc

cargo install starship
# FIXME
echo "eval \"$(starship init zsh)\"" >> ~/.zshrc

cargo install --git https://github.com/quentinproust/rust-teamwork-cli
echo "alias tw=teamwork-cli" >> ~/.zshrc

# =========================================================================================================
# python3, pip3
# =========================================================================================================
# this directory will be used to store python venv
mkdir ~/environments

# Install Python 3 and PIP.
sudo apt-get install -y python3.8 python3-pip python3-venv

python3 -m venv ~/environments/ansible-venv

# =========================================================================================================
# Install : docker, docker-compose
# =========================================================================================================
# source : https://nickjanetakis.com/blog/setting-up-docker-for-windows-and-wsl-to-work-flawlessly

# Install Docker's package dependencies.
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

# Download and add Docker's official public PGP key.
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Verify the fingerprint.
sudo apt-key fingerprint 0EBFCD88

# Add the `stable` channel's Docker upstream repository.
#
# If you want to live on the edge, you can change "stable" below to "test" or
# "nightly". I highly recommend sticking with stable!
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# Update the apt package list (for the new apt repo).
sudo apt-get update -y

# Install the latest version of Docker CE.
sudo apt-get install -y docker-ce

# Allow your user to access the Docker CLI without needing root access.
sudo usermod -aG docker $USER

# Install Docker Compose into your user's home directory.
pip3 install --user docker-compose

echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
echo "export DOCKER_HOST=tcp://localhost:2375" >> ~/.zshrc

# You should get a bunch of output about your Docker daemon.
# If you get a permission denied error, close + open your terminal and try again.
docker info

# You should get back your Docker Compose version.
docker-compose --version

# change windows drives mount to / instead of /mnt
sudo cat <<EOT >> /etc/wsl.conf
[automount]
root = /
options = "metadata"
EOT

# =========================================================================================================
# Aliases
# =========================================================================================================
echo "alias alt=altima-devops-cli" >> ~/.zshrc
echo "alias switch-java=\"sudo update-alternatives --config java\"" >> ~/.zshrc
echo "alias ansible-venv=\". ~/environments/ansible2.9-venv/bin/activate\"" >> ~/.zshrc

# =========================================================================================================
# Env
# =========================================================================================================
# init ~/.env to store various access tokens and global props
cat <<EOT >> ~/.env
export ARTIFACTORY_USER=
export ARTIFACTORY_PASSWORD=

export GITHUB_TOKEN=
export GITHUB_ACCESS_TOKEN=

export ARTIFACTORY_URL=
export ALT_SONAR_URL=

export CLEVER_TOKEN=
export CLEVER_SECRET=

export PORTAL_APP_ID=
export PORTAL_API_KEY=

export DEV_IZANAMI_STAGING_CLIENT_ID=
export DEV_IZANAMI_STAGING_CLIENT_SECRET=
export PRD_IZANAMI_CLIENT_ID=
export PRD_IZANAMI_CLIENT_SECRET=

export MULESOFT_AUTH_LOGIN=
export MULESOFT_AUTH_PASSWORD=
EOT

echo ". ~/.env" >> ~/.zshrc

# =========================================================================================================
# Git config
# =========================================================================================================
cat <<EOT >> ~/.gitconfig
[user]
	name = Quentin PROUST
	email = qproust@altima-assurances.fr

[diff]
	    tool = vscode
[difftool "vscode"]
	    cmd = code --wait --diff $LOCAL $REMOTE

[alias]
	addp = add --patch
	s = status -s
	lg = log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n %C(white)%s%C(reset) %C(dim white)- %an%C(reset)'
	l = log --graph --decorate --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --all
	lgs = log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s%Creset' --abbrev-commit
	ob = "!git fetch --all && git branch --all --merged | grep -v '*'"
	amend = commit --amend
	co = checkout
	drop-changes = checkout -- .
	dc = checkout -- .

[core]
	autocrlf = true
	editor = vim
	pager = delta --plus-color="#012800" --minus-color="#340001" --theme='Monokai Extended'
EOT

# =========================================================================================================
# Java, Maven & gradle
# =========================================================================================================
# create an alias for .m2 linking it to windows files
ln -s /c/Users/qproust/.m2 ~/.m2

# install openjdk
wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | sudo apt-key add -
sudo add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/
sudo apt-get update -y
sudo apt-get install -y adoptopenjdk-8-hotspot adoptopenjdk-11-hotspot adoptopenjdk-15-hotspot


# =========================================================================================================
# Nodejs
# =========================================================================================================

wget -qO- https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt install -y nodejs

# =========================================================================================================
# Notes and not so sure if needed ?
# =========================================================================================================

# nvm ??
# this is present in ~/.bashrc and ~/.zshrc
#   export NVM_DIR="$HOME/.nvm"
#   [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#   [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion