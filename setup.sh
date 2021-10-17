#!/bin/sh

set -e

dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

function dotconfig() {
	local config="${dir}/dots/$1"
	local dest="${HOME}/$2"
	mkdir -p $(dirname $dest)
	if [ -e "$dest" -a ! -L "$dest" ]; then
		>&2 echo "moving old config to ${dest}.old"
		mv "${dest}"{,.old}
	fi
	echo "linking $config -> $dest"
	ln -sf "$config" "$dest"
}

dotconfig init.vim .config/nvim/init.vim
dotconfig tmux.conf .tmux.conf
dotconfig bashrc .bashrc.local
