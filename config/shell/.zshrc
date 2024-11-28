#!/usr/bin/env zsh

### setup environment variables
export -U PATH path FPATH fpath MANPATH manpath
export -UT INFOPATH infopath
source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shared/env"

### zsh options


### commands & aliases
setopt AUTO_CD

