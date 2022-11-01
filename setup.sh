#!/bin/sh

set -eu

### global

dir=$(CDPATH="" cd -- "$(dirname -- "$0")" && pwd)
bin="$HOME/.local/bin"

### helper

is_command() {
  command -v "$1" >/dev/null
}

# TODO: support color outpt
log() {
  level="$1"
  msg="$2"
  printf "[%4s] %s\n" "$level" "$msg" 1>&2
}

error() {
  msg=$1
  log ERR "$msg"
  exit 1
}

log_done() {
  msg=$1
  log DONE "$msg"
}

warn() {
  msg=$1
  log WARN "$msg"
}

info() {
  msg=$1
  log INFO "$msg"
}

done_log() {
  msg=$1
  log DONE "$msg"
}

can_download() {
  if is_command curl || is_command wget;then
    return
  else
    return 1
  fi
}

download() {
  url=$1
  out=$2
  if is_command curl;then
    curl -Lso "$out" "$url"
  elif is_command wget;then
    wget -qO "$out" "$url"
  else
    error "curl or wget not found"
    return 1
  fi
}

### arg parsing

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
    error "usage: $0 <install/remove>"
    ;;
esac

### setup symbol links

add_link() {
  config="$dir/$1"
  dest="$HOME/$2"
  mkdir -p "$(dirname "$dest")"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    warn "moving file: $dest -> $dest.old"
    mv "$dest" "$dest.old"
  fi
  if [ ! -L "$dest" ] || [ "$(readlink -f "$dest")" != "$(readlink -f "$config")" ];then
    info "link: $dest -> $config"
    ln -sf "$config" "$dest"
  fi
}

del_link() {
  dest="$HOME/$2"
  if [ -L "$dest" ]; then
    info "unlink: $dest"
    rm "$dest"
    if [ -e "$dest.old" ]; then
       info "moving file: $dest.old -> $dest"
       mv "$dest.old" "$dest"
    fi
  fi
}

### dotconfig

add_dotconfig() {
  add_link "dots/$1" "$2"
}

del_dotconfig() {
  del_link "dots/$1" "$2"
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

### scripts

add_scripts() {
  for s in scripts/*; do
    add_link "$s" ".local/bin/$(basename "$s")"
  done
}

del_scripts() {
  for s in scripts/*; do
    del_link "$s" ".local/bin/$(basename "$s")"
  done
}

setup_scripts() {
  case $op in
    add)
      add_scripts
      ;;
    del)
      del_scripts
      ;;
  esac
}

### Neovim

nvim_src="https://github.com/neovim/neovim/releases/download/stable/nvim.appimage"
nvim="$bin/nvim"

install_nvim() {
  if can_download; then
    info "downloading $nvim"
    mkdir -p "$bin"
    if [ -f "$nvim" ];then
      rm -r "$nvim"
    fi
    download "$nvim_src" "$nvim" >/dev/null
    chmod +x "$nvim"
    if ! "$nvim" -v >/dev/null 2>&1;then
      warn "fuse not supported. extracting nvim"
      nvim_share="$HOME/.local/share/nvim"
      mkdir -p "$nvim_share"
      cd "$nvim_share"
      if $nvim --appimage-extract >/dev/null 2>&1;then
        ln -snf "$nvim_share/squashfs-root/AppRun" "$nvim"
      else
        rm "$nvim"
        warn "Failed to install nvim"
        return
      fi
    fi
    if "$nvim" -v >/dev/null 2>&1;then
      log_done "nvim installed"
    fi
  else
    warn "Unable to download nvim"
  fi
}

check_nvim() {
  if is_command nvim || [ -x "$nvim" ] ;then
    nvim_bin=
    if [ -x "$nvim" ];then
      nvim_bin="$nvim"
    else
      nvim_bin="nvim"
    fi
    min_major=7
    min_minor=0
    major=$(${nvim_bin} -v | head -n1 |cut -d '.' -f2)
    minor=$(${nvim_bin} -v | head -n1 |cut -d '.' -f3)
    if [ "$major" -ge "$min_major" ] && [ "$minor" -ge "$min_minor" ];then
      return
    else
      warn "current nvim version to low (need: >=v0.$min_major.$min_minor got: v$major.$minor)"
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

### Tmux

tmux="$bin/tmux"

install_tmux() {
  if can_download; then
    info "downloading $tmux"
    mkdir -p "$bin"
    if [ -f "$tmux" ];then
      rm -r "$tmux"
    fi

    # get latest version
    tmux_src="$(download "https://api.github.com/repos/nelsonenzo/tmux-appimage/releases/latest" - \
      | grep "browser_download_url.*appimage\"" | cut -d : -f 2,3 | cut -d \" -f2)"

    download "$tmux_src" "$tmux" >/dev/null
    chmod +x "$tmux"
    if ! "$tmux" -v >/dev/null 2>&1;then
      warn "fuse not supported. extracting tmux"
      tmux_share="$HOME/.local/share/tmux"
      mkdir -p "$tmux_share"
      cd "$tmux_share"
      if $tmux --appimage-extract >/dev/null 2>&1;then
        ln -snf "$tmux_share/squashfs-root/AppRun" "$tmux"
      else
        rm "$tmux"
        warn "Failed to install tmux"
        return
      fi
    fi
    if "$tmux" -v >/dev/null 2>&1;then
      log_done "tmux installed"
    fi
  else
    warn "Unable to download tmux"
  fi
}

check_tmux() {
  if is_command tmux || [ -x "$tmux" ] ;then
    return
  fi

  install_tmux
}
setup_tmux() {
  case $op in
    add)
      check_tmux
      ;;
    del)
      ;;
  esac
}

### Shell

profile="$dir/dots/profile"
profile_hook="[ -f $profile ] && . $profile"

del_profile_hook() {
  file="$1"
  if grep -Fq "dots/profile" "$HOME/$file" >/dev/null 2>&1; then
    info "remove $file profile hook"
    sed -i "/dots\/profile/d" "$HOME/$file"
  fi
}

add_profile_hook() {
  file="$1"
  if ! grep -Fxq "$profile_hook" "$HOME/$file" >/dev/null 2>&1; then
    del_profile_hook "$file"
    info "append $file profile hook"
    echo "$profile_hook" >> "$HOME/$file"
  fi
}

setup_shell() {
  case $op in
    add)
        add_profile_hook .profile
        add_profile_hook .bashrc
        add_profile_hook .zshrc
      ;;
    del)
        del_profile_hook .profile
        del_profile_hook .bashrc
        del_profile_hook .zshrc
      ;;
  esac
}

### Git

gitconfig="$HOME/.gitconfig"
name="Marcello Sylvester Bauer"
email="sylv@sylv.io"

add_config_git() {
  if is_command git;then
    if ! grep -Fxq "$name" "$gitconfig" >/dev/null 2>&1; then
      git config --global user.name "$name"
    fi
    if ! grep -Fxq "$email" "$gitconfig" >/dev/null 2>&1; then
      git config --global user.email "$email"
    fi
  else
    warn "git not installed"
  fi
}

del_config_git() {
  if [ -f "$gitconfig" ];then
    sed -i "/$name/d" "$gitconfig"
    sed -i "/$email/d" "$gitconfig"
  fi
}

setup_git() {
  case $op in
    add)
        add_config_git
      ;;
    del)
        del_config_git
      ;;
  esac
}

### ssh

add_sshkey() {
  ssh_auth="$HOME/.ssh/authorized_keys"
  sshkeys_url="https://github.com/sylv-io.keys"
  sshkey=""
  fallback_sshkey="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAblRU+lCR0PoFKjUKkhGtmR0nnhLrdc67mQWpQfu7wl $email"
  if can_download; then
    sshkey="$(download "$sshkeys_url" - | head -n1 || true) $email"
  fi
  if [ -z "$sshkey" ] || [ "$(echo "$sshkey" | wc -w)" -ne 3 ]; then
    warn "using fallback sshkey"
    sshkey="$fallback_sshkey"
  fi
  mkdir -p "$(dirname "$ssh_auth")"
  if ! grep -Fq "$(echo "$sshkey" | cut -d " " -f 2)" "$ssh_auth" >/dev/null 2>&1; then
    info "append ssh key"
    echo "$sshkey" >> "$ssh_auth"
  fi
}

setup_ssh() {
  case $op in
    add)
      add_sshkey
      ;;
    del)
      # keep sshkey
      ;;
  esac
}

### commands

check_cmds() {
  for cmd in tmux direnv;do
    if ! is_command $cmd;then
      warn "$cmd not installed"
    fi
  done
}

setup_cmds() {
  case $op in
    add)
      check_cmds
      ;;
    del)
      ;;
  esac
}

setup_done() {
  case $op in
    add)
      log_done "setup complete"
      ;;
    del)
      log_done "setup removed"
      ;;
  esac
}

main() {
  dotconfig nvim .config/nvim
  dotconfig tmux.conf .tmux.conf
  dotconfig lazygit.yml .config/lazygit/config.yml
  setup_scripts
  setup_git
  setup_ssh
  setup_shell
  setup_nvim
  #setup_tmux
  setup_cmds

  setup_done
}

main
