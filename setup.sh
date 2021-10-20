#!/bin/sh

set -e

dir=$(CDPATH="" cd -- "$(dirname -- "$0")" && pwd)
bin="$HOME/.local/bin"
bashrc_src="[ -f ~/.bashrc.local ] && source ~/.bashrc.local"

nvim_src="https://github.com/neovim/neovim/releases/download/stable/nvim.appimage"
nvim="$bin/nvim"

dotconfig() {
  config="$dir/dots/$1"
  dest="$HOME/$2"
  mkdir -p "$(dirname "$dest")"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    >&2 echo "moving old config to ${dest}.old"
    mv "$dest" "$dest.old"
  fi
  echo "link $config -> $dest"
  ln -sf "$config" "$dest"
}

bashrc_hook() {
  if ! grep -Fxq "$bashrc_src" "$HOME/.bashrc"; then
    echo "append \"$bashrc_src\" to .bashrc"
    echo "$bashrc_src" >> "$HOME/.bashrc"
  fi
}

install_nvim() {
  if [ ! -x "$nvim" ]; then
    echo "get $nvim"
    mkdir -p "$bin"
    tmp=$(mktemp)
    curl -Lo "$tmp" "$nvim_src" >/dev/null
    chmod +x "$tmp"
    mv "$tmp" "$nvim"
  fi
}

dotconfig init.vim .config/nvim/init.vim
dotconfig tmux.conf .tmux.conf
dotconfig bashrc .bashrc.local

install_nvim

bashrc_hook
