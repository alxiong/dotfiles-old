#!/bin/sh

## credit: https://github.com/emacs-mirror/emacs/blob/emacs-27/autogen.sh

## Echo the version string of a program/command
## $1 = program name, e.g. "emacs"
get_version() {
	vers=$($1 --version 2>/dev/null)
	if [ $? != 0 ]; then
		vers=$($1 version 2>/dev/null)
	fi
	expr "$vers" : '[^0-9]*\([0-9]*[.][0-9]*[.]*[0-9]*[0-9A-Za-z-]*\)'
}

# Echo the major version, eg "2".
## $1 = version string, eg "2.59"
major_version() {
	echo $1 | sed -e 's/\([0-9][0-9]*\)\..*/\1/'
}

## Echo the minor version, eg "59".
## $1 = version string, eg "2.59"
minor_version() {
	echo $1 | sed -e 's/[0-9][0-9]*\.\([0-9][0-9]*\).*/\1/'
}

## $1 = program
## $2 = minimum version.
## Return 0 if program is present with version >= minimum version.
## Return 1 if program is missing.
## Return 2 if program is present but too old.
## Return 3 for unexpected error (eg failed to parse version).
check_version() {
	## Respect, e.g., $AUTOCONF if it is set, like autoreconf does.
	uprog0=$(echo $1 | sed -e 's/-/_/g' -e 'y/abcdefghijklmnopqrstuvwxyz/ABCDEFGHIJKLMNOPQRSTUVWXYZ/')

	eval uprog=\$${uprog0}

	if [ x"$uprog" = x ]; then
		uprog=$1
	else
		printf '%s' "(using $uprog0=$uprog) "
	fi

	## /bin/sh should always define the "command" builtin, but
	## sometimes it does not on hydra.nixos.org.
	## /bin/sh = "BusyBox v1.27.2", "built-in shell (ash)".
	## It seems to be an optional compile-time feature in that shell:
	## see ASH_CMDCMD in <https://git.busybox.net/busybox/tree/shell/ash.c>.
	if command -v command >/dev/null 2>&1; then
		command -v $uprog >/dev/null || return 1
	else
		$uprog --version >/dev/null 2>&1 || return 1
	fi
	have_version=$(get_version $uprog) || return 4

	have_maj=$(major_version $have_version)
	need_maj=$(major_version $2)

	[ x"$have_maj" != x ] && [ x"$need_maj" != x ] || return 3

	[ $have_maj -gt $need_maj ] && return 0
	[ $have_maj -lt $need_maj ] && return 2

	have_min=$(minor_version $have_version)
	need_min=$(minor_version $2)

	[ x"$have_min" != x ] && [ x"$need_min" != x ] || return 3

	[ $have_min -ge $need_min ] && return 0
	return 2
}
