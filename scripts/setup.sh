#!/usr/bin/env bash

### shell options
set -e
set -x
set -u
set -o pipefail
(shopt -p inherit_errexit &>/dev/null) && shopt -s inherit_errexit

install_pkgs
