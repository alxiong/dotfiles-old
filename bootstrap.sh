#!/usr/bin/env bash

git pull origin master;
# sync up prezto, vimrc submodules
git submodule update --remote;

# Set up zsh using Prezto Framework: https://github.com/AlexXiong97/prezto
cd prezto/;
rsync -avzh ./* ${ZDOTDIR:-$HOME}/.zprezto;
## creating new zsh configuration:
setopt EXTENDED_GLOB;
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
    ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done
## set zsh as the default shell:
chsh -s /bin/zsh;
cd ../;

# Set up VIM using vimrc: https://github.com/AlexXiong97/vimrc
cd vimrc/;
rsync -avzh ./* ~/.vim_runtime;
sh ~/.vim_runtime/install_awesome_vimrc.sh;
cd ../;

# Copying other dotfiles
function doIt() {
	rsync --exclude ".git/" \
		--exclude "prezto" \
		--exclude "vimrc" \
		--exclude "bootstrap.sh" \
		--exclude "README.md" \
		--exclude "LICENSE" \
        --exclude ".gitmodules" \
		-avh --no-perms . ~;
	source ~/.bash_profile;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
	fi;
fi;
unset doIt;



