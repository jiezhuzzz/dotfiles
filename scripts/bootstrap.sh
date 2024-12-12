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

install_rio_terminfo
# install_blesh

if has_sudo; then
    set_default_shell
    install_nix
fi
