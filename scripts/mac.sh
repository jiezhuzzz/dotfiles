#! /usr/bin/env bash

function install_xcode_command_line_tools() {
    if ! xcode-select -p &>/dev/null; then
        info "Installing Xcode command line tools ..."
        xcode-select --install
    fi
    status "Xcode command line tools are already installed."
}

function install_nix() {
    if ! l.is_dir /nix; then
        info "Installing Nix as package manager ..."
        curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
    fi
    status "Nix is installed."
}

function install_nix_darwin() {
    nix run nix-darwin -- switch --flake ~/.config/nix-darwin
    darwin-rebuild switch --flake ~/.config/nix-darwin
}

function install_nix_home_manager() {
    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
    nix-channel --update
}


# execute functions in order
install_xcode_command_line_tools
install_nix
install_nix_darwin
install_nix_home_manager