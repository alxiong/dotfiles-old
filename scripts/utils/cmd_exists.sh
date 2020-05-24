#!/bin/sh

## credit: https://github.com/BurntSushi/dotfiles

cmd_exists() {
	if [ ! $# -eq 1 ]; then
		echo "usage: $(basename $0) command"
	fi
	command -v $1 >/dev/null 2>&1
}
