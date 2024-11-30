#! /bin/bash

### shell options
set -e
set -u
set -o pipefail
(shopt -p inherit_errexit &>/dev/null) && shopt -s inherit_errexit

function install_xcode_command_line_tools() {
    if ! xcode-select -p &>/dev/null; then
        info "Installing Xcode command line tools ..."
        xcode-select --install
    fi
    status "Xcode command line tools are already installed."
}

function install_rio_terminfo() {
    if ! infocmp rio &>/dev/null; then
        info "Installing rio terminfo..."
        curl -o rio.terminfo https://raw.githubusercontent.com/raphamorim/rio/main/misc/rio.terminfo
        tic -x rio.terminfo && rm rio.terminfo
    fi
    status "rio terminfo is already installed."
}

function install_nix() {
    if ! has_cmd "nix"; then
        if [[ $(os) == "darwin" ]]; then
            _install_nix_mac
        else
            _install_nix_linux
        fi
    fi
    status "Nix is installed."
}

function install_nix_flakes() {
    local nix_dir="$DOTFILES_DIR"/nix
    local nix_template_dir="$DOTFILES_DIR"/templates/nix/"$(os)"
    local nix_files

    prepare_dir "$nix_dir"

    nix_files=$(find -L "$nix_template_dir" -type f -name "*.nix")
    for file in $nix_files; do
        relative_path=$(relative_path "$nix_template_dir" "$file")
        local output_file="$nix_dir"/"$relative_path"
        prepare_dir "$(dirname "$output_file")"
        mo "$file" > "$output_file"
    done
}

function install_blesh() {
    if has_cmd "ble-update"; then
        info "Installing ble.sh..."
        local ble_sh_dir="/tmp/ble.sh"
        git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git "$ble_sh_dir"
        make -C "$ble_sh_dir" install PREFIX="$HOME"/.local
    fi
    status "ble.sh is installed."
}

function install_pkgs() {
    if has_cmd "nix"; then
        info "Installing packages with Nix..."
        nix-channel --add https://nixos.org/channels/nixpkgs-unstable
        nix-channel --update
        # TODO: install packages
    else
        info "Nix is not installed. Installing packages without sudo..."
        _install_pkgs_nosudo
    fi
    status "All packages installed."
}

### internal functions

function _install_nix_mac() {
    info "Installing Nix on MacOS..."
    # install nix
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
    # install nix-darwin
    nix run nix-darwin -- switch --flake ~/.config/nix-darwin
    darwin-rebuild switch --flake ~/.config/nix-darwin
    # install nix-home-manager
    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
    nix-channel --update
}

function _install_nix_linux() {
    info "Installing Nix on Linux..."
    sh <(curl -L https://nixos.org/nix/install) --daemon #TODO: no confirm
}

function _install_pkgs_nosudo() {
    _prepare_install_dir
    while read -r cmd pkg_name url; do
        if has_cmd "$cmd"; then
            continue
        fi
        _install_pkg "$cmd" "$pkg_name" "$url"
    done <"$DOTFILES_DIR"/pkgs.list
}

function _prepare_install_dir() {
    local pkg_install_prefix="$HOME/.local/bin"
    if [[ ! -d "$pkg_install_prefix" ]]; then
        mkdir -p "$pkg_install_prefix"
    fi
}

function _install_pkg() {
    local cmd="$1" pkg_name="$2" url="$3"
    info "Installing $pkg_name ..."
    local tmp_extract_dir
    tmp_extract_dir="/tmp/$pkg_name"
    _extract_pkg "$url" "$tmp_extract_dir"
    _move_pkg "$cmd" "$tmp_extract_dir"
}

function _extract_pkg() {
    local url="$1" tmp_extract_dir="$2"
    if [[ "$url" == *.tar.gz ]]; then
        curl -L "$url" -o /tmp/"$pkg_name".tar.gz
        tar -xzf /tmp/"$pkg_name".tar.gz -C "$tmp_extract_dir"
    elif [[ "$url" == *.zip ]]; then
        curl -L "$url" -o /tmp/"$pkg_name".zip
        unzip /tmp/"$pkg_name".zip -d "$tmp_extract_dir"
    else
        warn "Unsupported package archive for $pkg_name"
    fi
}

function _move_pkg() {
    local cmd="$1" tmp_extract_dir="$2" pkg_file
    pkg_file=$(find "$tmp_extract_dir" -type f -name "$cmd")
    if [[ -x "$pkg_file" ]]; then
        mv "$pkg_file" "$HOME/.local/bin"
    fi
}
