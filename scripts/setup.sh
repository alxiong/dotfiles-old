#!/bin/sh

set -e

# import helper functions
DIR=$(dirname $0)
. $DIR/utils/all.sh

# echo 📂 Syncing dotfiles ...
# cd $HOME
# ## during a new machine setup, move existing config to ~/temp/old/
# if [ ! -f "$HOME/.zprofile" ]; then
# 	trash=".bashrc .bash_logout .bash_profile .profile .vimrc"
# 	mkdir -p ./temp/old
# 	for f in $trash; do
# 		if [ -f "$f" ]; then
# 			mv "$f" ./temp/old
# 		fi
# 	done
# fi
# if [ ! -d "$HOME/.git" ]; then
# 	git init
# 	git remote add origin https://github.com/alxiong/dotfiles
# 	git branch --set-upstream-to origin/master master
# fi
# git pull origin master --ff-only
# git submodule update --recursive --remote

# # Configure git
# sh $DIR/configure_git.sh

# Check necessary commands, tools, programs installed
sh $DIR/check_cmd.sh
if [ $? = 1 ]; then
	exit 1
fi

# Configure emacs

# Configure zsh

# Configure vim

# Rebind CapsLock to Ctrl (for easier Emacs C-x)
echo 🔧 Rebinding CapsLock to Ctrl ...
xmodmap ~/.Xmodmaprc
