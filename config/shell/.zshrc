#!/usr/bin/env zsh

### setup environment variables
export -U PATH path FPATH fpath MANPATH manpath
export -UT INFOPATH infopath

for file in "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shared/"*; do
    source "$file"
done

export SHELDON_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/sheldon/zsh"


### zsh options


### commands & aliases
setopt AUTO_CD

eval_if_cmd atuin "init zsh"
eval_if_cmd starship "init zsh"
