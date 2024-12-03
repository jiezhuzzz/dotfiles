#!/usr/bin/env bash

### shell options
set -e
set -u
set -o pipefail
(shopt -p inherit_errexit &>/dev/null) && shopt -s inherit_errexit

set_config
### bootstrap system

# interactive setup
status "Bootstraping system now ..."
set_git

# install dependencies
if [ "$(os)" == "macos" ]; then
    install_xcode_command_line_tools
fi

install_rio_terminfo
# install_blesh

if has_sudo; then
    set_default_shell
    install_nix
    install_nix_flakes
fi
