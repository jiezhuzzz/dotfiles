#!/usr/bin/env bash

### shell options
set -e
set -u
set -o pipefail
(shopt -p inherit_errexit &>/dev/null) && shopt -s inherit_errexit

### set up lobash
source scripts/utils.sh
enable_lobash

### config your git
#set_up_git

### Bootstrap system
os=$(l.detect_os)

status "Bootstraping $os now ..."

if [ "$os" == "MacOS" ]; then
    hostname=$(scutil --get LocalHostName)
    source scripts/mac.sh
    install_xcode_command_line_tools
    install_nix
else
    hostname=$(l.hostname)
    status "Unsupported OS: $os"
    exit 1
fi


exit 0

# install homebrew
if sudo -v >/dev/null 2>&1; then
    echo "Install homebrew globally"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Install homebrew locally"
    homebrew_prefix="$HOME"/.homebrew
    mkdir "$homebrew_prefix" && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip-components 1 -C "$homebrew_prefix"
    eval "$("$homebrew_prefix"/bin/brew shellenv)"
    brew update --force --quiet
fi

# install packages from Brewfile
os=$(uname -s | tr '[:upper:]' '[:lower:]')
brew bundle install --file="${PWD}/brew/${os}.brew"

if [ "$os" == "darwin" ]; then
    ln -s "${PWD}/shell/.zshrc" "${HOME}/.zshrc"
elif [ "$os" == "linux" ]; then
    ln -s "${PWD}/shell/.bashrc" "${HOME}/.bashrc"
    echo "Install ble.sh"
    git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git
    make -C ble.sh install PREFIX=~/.local
fi

ln -s "${PWD}/config" "${HOME}/.config"
