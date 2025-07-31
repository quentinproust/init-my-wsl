#!/bin/sh
set -eux

# =========================================================================================================
# Update the apt package list.
# =========================================================================================================
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y build-essential curl file git software-properties-common pkg-config libssl-dev dos2unix

# =========================================================================================================
# Install homebrew
# =========================================================================================================
#https://brew.sh/
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo >> /home/qproust/.bashrc
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/qproust/.bashrc
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Install packages
brew install eza
bat
fd
fzf
graphviz
jq
lsd
miniserve
starship
structurizr-cli
watchexec
zsh
atuin

# run zsh for the first time to init it
zsh
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/qproust/.zshrc

# configure atuin
echo 'eval "$(atuin init zsh)"' >> ~/.zshrc

# configure starship
eval "$(starship init zsh)" >> ~/.zshrc

# add alias
echo "alias lll='exa -la'" >> ~/.zshrc
echo "alias ls='lsd'" >> ~/.zshrc
echo "alias ll='lsd -l'" >> ~/.zshrc

# add zsh to /etc/shells
command -v zsh | sudo tee -a /etc/shells
chsh -s $(which zsh)
# restart your console
echo $SHELL

starship preset catppuccin-powerline -o ~/.config/starship.toml

# =========================================================================================================
# Install : zsh, oh-my-zsh
# =========================================================================================================
#sudo apt-get install -y zsh
# restart your console
#chsh -s $(which zsh)
# restart your console
#echo $SHELL

#sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# =========================================================================================================
# Install : rust & companions :)
# =========================================================================================================
#curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
#. $HOME/.cargo/env

#sudo apt install bat
#cargo install broot
#cargo install git-delta
#cargo install clog ??? FIXME
#cargo install dust ??? FIXME
#cargo install watchexec-cli
#cargo install fzf

#sudo apt-get install exa
#cargo install lsd
#echo "alias lll='exa -la'" >> ~/.zshrc
#echo "alias ls='lsd'" >> ~/.zshrc
#echo "alias ll='lsd -l'" >> ~/.zshrc

#cargo install fd-find
#echo "alias fd=fdfind" >> ~/.zshrc

#curl -sS https://starship.rs/install.sh | sh
#echo "eval \"$(starship init zsh)\"" >> ~/.zshrc

# disable these lines in zshrc :
# autoload -Uz promptinit
# promptinit
# prompt adam1


# =========================================================================================================
# python3, pip3
# =========================================================================================================
# See miniconda for an alternative

# this directory will be used to store python venv
mkdir ~/environments

# Install Python 3 and PIP.
#sudo apt-get install -y python3.8 python3-pip python3-venv

python3 -m venv ~/environments/ansible-venv

# =========================================================================================================
# Install : docker, docker-compose
# =========================================================================================================
#https://docs.docker.com/engine/install/ubuntu/

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo groupadd docker
sudo usermod -aG docker $USER

sudo systemctl enable docker.service
sudo systemctl enable containerd.service


# Expose docker to tcp://127.0.0.1:2375
# /etc/systemd/system/docker.service.d/override.conf

#[Service]
#ExecStart=
#ExecStart=/usr/bin/dockerd -H fd:// -H tcp://127.0.0.1:2375 --containerd=/run/containerd/containerd.sock

# In Windows, install docker cli and set DOCKER_HOST
# winget install --id=Docker.DockerCLI  -e
# setx DOCKER_HOST=localhost:2375

# =========================================================================================================
# Install sql server command line
# https://docs.microsoft.com/fr-fr/sql/linux/sql-server-linux-setup-tools?view=sql-server-ver15#ubuntu
# =========================================================================================================

curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list | sudo tee /etc/apt/sources.list.d/msprod.list
sudo apt-get update
sudo apt-get install mssql-tools unixodbc-dev

# =========================================================================================================
# Aliases
# =========================================================================================================
echo "alias alt=altima-devops-cli" >> ~/.zshrc
echo "alias switch-java=\"sudo update-alternatives --config java\"" >> ~/.zshrc
echo "alias ansible-venv=\". ~/environments/ansible2.9-venv/bin/activate\"" >> ~/.zshrc
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.zshrc

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

brew install openjdk@21

# =========================================================================================================
# Nodejs
# =========================================================================================================
brew install nvm
