#!/usr/bin/env bash

### shell options
set -e
set -x
set -u
set -o pipefail
(shopt -p inherit_errexit &>/dev/null) && shopt -s inherit_errexit

# constants
DOTFILES_DIR=$PWD
SCRIPTS_DIR="$DOTFILES_DIR"/scripts

### load functions
for script in "$SCRIPTS_DIR"/*.sh; do
    source "$script"
done

install_blesh
install_pkgs
