#!/usr/bin/env bash

### shell options
set -e
set -u
set -o pipefail
(shopt -p inherit_errexit &>/dev/null) && shopt -s inherit_errexit

# constants
DOTFILES_DIR=$PWD
SCRIPTS_DIR="$DOTFILES_DIR"/scripts
SCRIPTS_LIB="$SCRIPTS_DIR"/lib

### load functions
for script in "$SCRIPTS_LIB"/*.sh; do
    source "$script"
done


# parse args, it bootsraps the system
if [[ $# -ne 1 ]]; then
    error "Exactly one command is required"
fi

case $1 in
bootstrap)
    source "$SCRIPTS_DIR"/bootstrap.sh
    ;;
setup)
    source "$SCRIPTS_DIR"/setup.sh
    ;;
*)
    error "Unknown command: $1"
    ;;
esac
