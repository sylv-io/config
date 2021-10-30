#!/bin/sh

set -e

name="Marcello Sylvester Bauer"
email="sylv@sylv.io"
dir=$(CDPATH="" cd -- "$(dirname -- "$0")" && pwd)
bin="$HOME/.local/bin"
bashrc="$dir/dots/bashrc"
bash_hook="[ -f $bashrc ] && source $bashrc"
gitconfig="$HOME/.gitconfig"

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
    echo "downloading $nvim"
    mkdir -p "$bin"
    download "$nvim_src" "$nvim" >/dev/null
    chmod +x "$nvim"
    if ! "$nvim" -v >/dev/null 2>&1;then
      nvim_share="$HOME/.local/share/nvim"
      mkdir -p "$nvim_share"
      cd "$nvim_share"
      if $nvim --appimage-extract >/dev/null 2>&1;then
        ln -snf "$nvim_share/squashfs-root/AppRun" "$nvim"
      else
        rm "$nvim"
        echoerr "Failed to install neovim"
      fi
    fi
  fi
}

check_nvim() {
  if is_command nvim;then
    version=$(nvim -v | head -n1 |cut -d '.' -f2)
    if [ "$version" -ge 5 ];then
      return
    else
      echo "nvim vesion to low (<v0.5)"
    fi
  fi
  install_nvim
}

setup_nvim() {
  case $op in
    add)
      check_nvim
      ;;
    del)
      ;;
  esac
}

add_bashrc_hook() {
  if ! grep -Fxq "$bash_hook" "$HOME/.bashrc" >/dev/null 2>&1; then
    echo "append: \"$bash_hook\" to .bashrc"
    echo "$bash_hook" >> "$HOME/.bashrc"
  fi
}

del_bashrc_hook() {
  if grep -Fq "dots/bashrc" "$HOME/.bashrc" >/dev/null 2>&1; then
    echo "remove: \"$bash_hook\" from .bashrc"
    sed -i "/dots\/bashrc/d" "$HOME/.bashrc"
  fi
}

setup_bash() {
  case $op in
    add)
        add_bashrc_hook
      ;;
    del)
        del_bashrc_hook
      ;;
  esac
}

config_git() {
  if is_command git;then
    if ! grep -Fxq "$name" "$gitconfig" >/dev/null 2>&1; then
      git config --global user.name "$name"
    fi
    if ! grep -Fxq "$email" "$gitconfig" >/dev/null 2>&1; then
      git config --global user.email "$email"
    fi
  fi
}

setup_git() {
  case $op in
    add)
        config_git
      ;;
    del)
      ;;
  esac
}

dotconfig init.vim .config/nvim/init.vim
dotconfig tmux.conf .tmux.conf
setup_nvim
setup_bash
setup_git
