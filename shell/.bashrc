# XDG environment
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

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

[ -s "/home/linuxbrew/.linuxbrew/opt/jabba/share/jabba/jabba.sh" ] && . "/home/linuxbrew/.linuxbrew/opt/jabba/share/jabba/jabba.sh"

[[ ${BLE_VERSION-} ]] && ble-attach
