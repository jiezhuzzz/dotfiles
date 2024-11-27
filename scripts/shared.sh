#! /usr/bin/env bash

# this script is shared between MacOS and Linux
function install_blesh() {
    local ble_sh_dir="/tmp/ble.sh"
    git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git $ble_sh_dir
    make -C $ble_sh_dir install PREFIX=~/.local
}
