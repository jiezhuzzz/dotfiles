#!/bin/bash

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
