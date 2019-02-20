#!/usr/bin/env bash
pwd=$(pwd)

git pull origin master;
git submodule update --init --recursive;

# Set up zsh using Prezto Framework: https://github.com/AlexXiong97/prezto
cd prezto/;
rsync -avzh ./ ~/.zprezto;
zsh;

# install rbenv
git clone https://github.com/rbenv/rbenv.git ~/.rbenv;
cd ~/.rbenv && src/configure && make -C src;
## NOTE: rbenv path is already added into ~/.zshenv
source ~/.zshrc;
curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-doctor | bash; # check rbenv install status

# install virtualenvwrapper
pip install virtualenvwrapper;

## creating new zsh configuration:
echo "setopt EXTENDED_GLOB;
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done" >> ~/.zshrc;
## set zsh as the default shell:
chsh -s /bin/zsh;

# setup prezto-contrib
cd $ZPREZTODIR
git clone https://github.com/belak/prezto-contrib contrib
cd contrib
git submodule init
git submodule update

cd pwd;

# pre vim setup environment setup
npm install -g neovim typescript

# Set up VIM using vimrc: https://github.com/AlexXiong97/vimrc
cd vimrc/;
rsync -avzh ./ ~/.vim_runtime;
sh ~/.vim_runtime/install_awesome_vimrc.sh;
cd ../;

# install Fira fonts
fonts_dir="${HOME}/.local/share/fonts"
if [ ! -d "${fonts_dir}" ]; then
  echo "mkdir -p $fonts_dir"
  mkdir -p "${fonts_dir}"
else
  echo "Found fonts dir $fonts_dir"
fi

for type in Bold Light Medium Regular Retina; do
  file_path="${HOME}/.local/share/fonts/FiraCode-${type}.ttf"
  file_url="https://github.com/tonsky/FiraCode/blob/master/distr/ttf/FiraCode-${type}.ttf?raw=true"
  if [ ! -e "${file_path}" ]; then
    echo "wget -O $file_path $file_url"
    wget -O "${file_path}" "${file_url}"
  else
    echo "Found existing file $file_path"
  fi;
done

echo "fc-cache -f"
fc-cache -f

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

# install editorconfig
apt-get --assume-yes install editorconfig;

# setup neovim
apt-get --assume-yes install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip;
npm install -g neovim;
git clone git@github.com:neovim/neovim.git ~/;
cd neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo && sudo make install;
mkdir ~/.config/nvim/;
rsync-copy pwd/nvim/init.vim ~/.config/nvim/;

## setup dein.vim 
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
## For example, we just use `~/.cache/dein` as installation directory
sh ./installer.sh ~/.cache/dein


