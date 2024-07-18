# XDG environment
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export PYENV_ROOT="$HOME/.pyenv"
# Export homebrew environment
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Enable ble.sh
[[ $- == *i* ]] && source "$XDG_DATA_HOME"/blesh/ble.sh --noattach

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# disable history
set +o history

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
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

[[ ${BLE_VERSION-} ]] && ble-attach
