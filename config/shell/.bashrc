#!/usr/bin/env bash

# Enable ble.sh
[[ $- == *i* ]] && source "$XDG_DATA_HOME"/blesh/ble.sh --noattach --rcfile "$XDG_CONFIG_HOME"/blesh/ble.rc

source "$XDG_CONFIG_HOME"/shell/env

export SHELDON_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/sheldon/bash"



eval_if_cmd atuin "init bash"
eval_if_cmd starship "init bash"

[[ ${BLE_VERSION-} ]] && ble-attach
