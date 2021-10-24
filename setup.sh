#!/bin/sh

set -e

dir=$(CDPATH="" cd -- "$(dirname -- "$0")" && pwd)
bin="$HOME/.local/bin"

is_command() {
  command -v "$1" >/dev/null
}

echoerr() {
  echo "$@" 1>&2
}

die() {
  echoerr "$@"
  exit 1
}

# default
arg="${1:-install}"

case $arg in
  install)
    op="add"
    ;;
  remove|uninstall)
    op="del"
    ;;
  *)
    die "usage: $0 <install/remove>"
    ;;
esac

download() {
  url=$1
  out=$2
  if is_command curl;then
    curl -Lo "$out" "$url" >/dev/null
  elif is_command wget;then
    wget -O "$out" "$url" >/dev/null
  else
    echoerr "curl or wget not found"
  fi
}

add_dotconfig() {
  config="$dir/dots/$1"
  dest="$HOME/$2"
  mkdir -p "$(dirname "$dest")"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    echo "move: old $dest -> $dest.old"
    mv "$dest" "$dest.old"
  fi
  echo "link: $dest -> $config"
  ln -sf "$config" "$dest"
}

del_dotconfig() {
  dest="$HOME/$2"
  if [ -L "$dest" ]; then
    echo "unlink: $dest"
    rm "$dest"
    if [ -e "$dest.old" ]; then
       echo "move: $dest.old -> $dest"
       mv "$dest.old" "$dest"
    fi
  fi
}

dotconfig() {
  case $op in
    add)
      add_dotconfig "$1" "$2"
      ;;
    del)
      del_dotconfig "$1" "$2"
      ;;
  esac
}

install_nvim() {
  nvim_src="https://github.com/neovim/neovim/releases/download/stable/nvim.appimage"
  nvim="$bin/nvim"
  if [ ! -x "$nvim" ]; then
    echo "get $nvim"
    mkdir -p "$bin"
    download "$nvim_src" "$nvim" >/dev/null
    chmod +x "$nvim"
  fi
}

setup_nvim() {
  case $op in
    add)
      install_nvim
      ;;
    del)
      ;;
  esac
}

bashrc="$dir/dots/bashrc"
bash_hook="[ -f $bashrc ] && source $bashrc"

add_bashrc_hook() {
  if ! grep -Fxq "$bash_hook" "$HOME/.bashrc" >/dev/null; then
    echo "append: \"$bash_hook\" to .bashrc"
    echo "$bash_hook" >> "$HOME/.bashrc"
  fi
}

del_bashrc_hook() {
  if grep -Fq "dots/bashrc" "$HOME/.bashrc" >/dev/null; then
    echo "remove: \"$bash_hook\" from .bashrc"
    sed -i "/dots\/bashrc/d" "$HOME/.bashrc"
  fi
}

bashrc_hook() {
  case $op in
    add)
        add_bashrc_hook
      ;;
    del)
        del_bashrc_hook
      ;;
  esac
}

dotconfig init.vim .config/nvim/init.vim
dotconfig tmux.conf .tmux.conf
setup_nvim
bashrc_hook
