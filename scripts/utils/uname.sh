#!/bin/sh

## 0: Linux; 1: Macos
get_os() {
	if [ $(uname) = "Linux" ]; then
		return 0
	elif [ $(uname) = "Darwin" ]; then
		return 1
	fi
}

## 0: work qubes; 1: personal or personal work qubes
work_or_home() {
	if [ $(uname -a | awk '{ print $2 }') = "work" ]; then
		return 0
	else
		return 1
	fi
}
