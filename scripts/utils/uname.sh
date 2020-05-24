#!/bin/sh

## 0: Linux; 1: Macos
get_os() {
	if [ $(uname) = "Darwin" ]; then
		return 0
	elif [ $(uname) = "Darwin" ]; then
		return 1
	fi
}
