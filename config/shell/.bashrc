#!/usr/bin/env bash

# Enable ble.sh
[[ $- == *i* ]] && source "$XDG_DATA_HOME"/blesh/ble.sh --noattach

eval "$(atuin init bash)"
eval "$(starship init bash)"

alias vim="nvim"
alias vi="nvim"
alias grep="rg"
#alias ls="eza"
alias g="git"
alias cp="cp -i"
alias mv="mv -i"
alias untar="tar -xvf"
alias mvn="mvn -gs $XDG_CONFIG_HOME/maven/settings.xml"
alias wget=wget --hsts-file="$XDG_DATA_HOME/wget-hsts"
alias svn="svn --config-dir $XDG_CONFIG_HOME/subversion"

pbcopy() {
  stdin=$(</dev/stdin)
  pbcopy="$(which pbcopy)"
  if [[ -n "$pbcopy" ]]; then
    echo "$stdin" | "$pbcopy"
  else
    echo "$stdin" | xclip -selection clipboard
  fi
}

pbpaste() {
  pbpaste="$(which pbpaste)"
  if [[ -n "$pbpaste" ]]; then
    "$pbpaste"
  else
    xclip -selection clipboard
  fi
}

function yy() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/sdkman-init.sh"

[[ ${BLE_VERSION-} ]] && ble-attach
