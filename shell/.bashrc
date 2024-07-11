#!/bin/bash

source ./xdg

# If not running interactively, don't do anything
case $- in
	*i*) ;;
	*) return;;
esac

# disable history
set +o history

[[ $- == *i* ]] && source "$XDG_DATA_HOME"/blesh/ble.sh --noattach


[[ ${BLE_VERSION-} ]] && ble-attach