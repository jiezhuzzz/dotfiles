#!/usr/bin/env bash

### shell options
set -e
set -u
set -o pipefail
(shopt -p inherit_errexit &>/dev/null) && shopt -s inherit_errexit

# constants
DOTFILES_DIR=$PWD
SCRIPTS_DIR="$DOTFILES_DIR"/scripts

### load functions
if [[ ! -f "$SCRIPTS_DIR"/mo.sh ]]; then
    curl -sSL https://raw.githubusercontent.com/tests-always-included/mo/master/mo -o "$SCRIPTS_DIR"/mo.sh
fi
for script in "$SCRIPTS_DIR"/*.sh; do
    source "$script"
done

set_config
### bootstrap system

# interactive setup
status "Bootstraping system now ..."
set_git

# install dependencies
if [ "$(os)" == "macos" ]; then
    install_xcode_command_line_tools
fi

if has_sudo; then
    set_default_shell
    install_nix
    install_nix_flakes
fi
