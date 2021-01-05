#!/bin/sh

set -e

# import helper functions
DIR=$(dirname "$0")
. $DIR/utils/all.sh

echo 📂 Syncing dotfiles ...
cd "$HOME"
OLD_DIR="$HOME/temp/old"
## during a new machine setup, move existing config to ~/temp/old/
if [ ! -f "$HOME/.zprofile" ]; then
	trash=".bashrc .bash_logout .bash_profile .profile"
	mkdir -p "$OLD_DIR"
	for f in $trash; do
		if [ -f "$f" ]; then
			mv "$f" "$OLD_DIR"
		fi
	done
fi
if [ ! -d "$HOME/.git" ]; then
	git init
	git remote add origin https://github.com/alxiong/dotfiles
	git branch --set-upstream-to origin/master master
fi
git pull origin master --ff-only

echo "⬇️ Recursively updating submodules (doom emacs, zprezto) ..."
if [ ! -f "$HOME/.emacs.d/init.el" ]; then
	# if the ~/.emacs.d/ folder is created by default emacs, not Doom Emacs,
	# then remove the current folder and clone Doom Emacs: https://github.com/hlissner/doom-emacs instead
	mv "$HOME/.emacs.d" "$OLD_DIR"
fi
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
# NOTE: no configurations for vim, to prioritize emacs whenever possible, just minimal vim shall do

# Rebind CapsLock to Ctrl (for easier Emacs C-x)
echo 🔧 Rebinding CapsLock to Ctrl ...
xmodmap ~/.Xmodmaprc

# Configure emacs
echo 🔧 Configuring Doom Emacs ...
~/.emacs.d/bin/doom -y install
