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
    set_default_shell
    hostname=$(scutil --get LocalHostName)
    source scripts/mac.sh
else # Linux
    # test if you have sudo access
    l.if $(sudo -n true 2>/dev/null) 
    if sudo -n true 2>/dev/null; then
        source scripts/linux.sh
    else
        info "You do not have sudo access. Please run this script with sudo."
    fi
fi



exit 0

ln -s "${PWD}/config" "${HOME}/.config"
