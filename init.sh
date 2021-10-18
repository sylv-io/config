#!/bin/sh
set -e

config_dir="${HOME}/.local/share/config"
git_config="$config_dir/.git/config"
repo="https://github.com/sylv-io/config.git"

is_command() {
  command -v "$1" >/dev/null
}

echoerr() {
  echo "$@" 1>&2
}

fetch() {
  echo "fetch: config"
  if is_command git; then
    config=$(dirname "$config_dir")
    rm -rf "$config_dir"
    mkdir -p "$config"
    cd "$config"
    git clone -q $repo
    return
  fi
  # TODO: support curl/wget unzip
  echoerr "fetch: unable to find git"
  return 1
}

update() {
  echo "update: config"
  if is_command git; then
    cd "$config_dir"
    git pull -q || fetch
    return
  fi
  echoerr "fetch: unable to find git"
  return 1
}

setup() {
  if [ ! -f "$git_config" ]; then
    fetch
  else
    update
  fi
  cd "$config_dir"
  echo "setup: config"
  ./setup.sh
}

setup
