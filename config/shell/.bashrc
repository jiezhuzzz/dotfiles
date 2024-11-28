export XDG_CONFIG_HOME="$HOME/.config"
hostname=$(hostname)
if [ "$hostname" == "goku" ] || [ "$hostname" == "vegeta" ]; then
    server_home="/zp_${hostname}/scratch_sb/jiez"
    bin_extra="/zp_${hostname}/scratch_lb/jiez/3rd"
    export XDG_CACHE_HOME="$server_home/.cache"
    export XDG_DATA_HOME="$server_home/.local/share"
    export XDG_STATE_HOME="$server_home/.local/state"
else
    export XDG_CACHE_HOME="$HOME/.cache"
    export XDG_DATA_HOME="$HOME/.local/share"
    export XDG_STATE_HOME="$HOME/.local/state"
fi

if [ -n "$bin_extra" ]; then
  export PATH="$PATH:${bin_extra}/starship"
else
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi


# xdg-ninja
export PYENV_ROOT="$XDG_DATA_HOME"/pyenv
export DOTNET_CLI_HOME="$XDG_DATA_HOME"/dotnet
export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle
export SDKMAN_DIR="$XDG_DATA_HOME"/sdkman
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME"/npm/npmrc
export NODE_REPL_HISTORY="$XDG_DATA_HOME"/node_repl_history
export ANDROID_USER_HOME="$XDG_DATA_HOME"/android
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export PERL_CPANM_HOME="$XDG_CACHE_HOME"/cpanm
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export TERMINFO="$XDG_DATA_HOME"/terminfo
export TERMINFO_DIRS="$XDG_DATA_HOME"/terminfo:/usr/share/terminfo
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
export RYE_HOME="$XDG_DATA_HOME"/rye
export SONARLINT_USER_HOME="$XDG_DATA_HOME/sonarlint"
export SQLITE_HISTORY="$XDG_CACHE_HOME"/sqlite_history
export PYTHONSTARTUP="$XDG_CONFIG_HOME"/python/pythonrc

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
