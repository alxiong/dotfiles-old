#!/bin/sh

set -e

# import helper functions
DIR=$(dirname "$0")
. $DIR/utils/all.sh

echo 📂 Syncing dotfiles ...
cd "$HOME"
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
if [ ! -d "$HOME/.git" ]; then
	git init
	git remote add origin https://github.com/alxiong/dotfiles
	git branch --set-upstream-to origin/master master
fi
git pull origin master --ff-only
git submodule update --recursive --remote

# Check necessary commands, tools, programs installed
sh "$DIR/check_cmd.sh"
if [ $? = 1 ]; then
	exit 1
fi

# Configure git
sh "$DIR/configure_git.sh"

# Configure zsh using zprezto framework
echo 🔧 Configuring Zsh ...
if [ ! -f "$HOME/.zpreztorc" ]; then
	for file in "$HOME"/.zprezto/runcoms/*; do
		filename=$(basename "$file")
		if [ "$filename" != "README.md" ]; then
			ln -s "$file" "$HOME/.$filename"
		fi
	done

	cd "$HOME/.zprezto"
	git submodule update --init
	git clone --recurse-submodules https://github.com/belak/prezto-contrib contrib
	zsh >/dev/null 2>&1
	chsh -s /bin/zsh
else
	echo Already exists, skipping!
fi

# Configure vim using amix/vimrc framework

# Rebind CapsLock to Ctrl (for easier Emacs C-x)
echo 🔧 Rebinding CapsLock to Ctrl ...
xmodmap ~/.Xmodmaprc

# Configure emacs
echo 🔧 Configuring Doom Emacs ...
~/.emacs.d/bin/doom -y install
