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
for script in "$SCRIPTS_DIR"/*.sh; do
    source "$script"
done

set_config
### bootstrap system

# interactive setup
status "Bootstraping system now ..."
set_git

# install dependencies
if [ "$(os)" == "darwin" ]; then
    install_xcode_command_line_tools
fi

if has_sudo; then
    set_default_shell
    install_nix
fi
