#!/bin/bash

# this script provides utility functions

function enable_lobash() {
    local lobash="$PWD/scripts/lobash.bash"
    if [ ! -f "$lobash" ]; then
        git clone https://github.com/adoyle-h/lobash.git /tmp/lobash && /tmp/lobash/build $PWD/scripts
    fi
    source $lobash
}

function status() {
    l.echo "\e[32m$1\e[0m"
}

function info() {
    l.echo "$1"
}

function set_up_git() {
    while true; do
        local username=$(l.ask_input "What's your git username?")
        git config --global user.name "$username"

        local email=$(l.ask_input "What's your git email?")
        git config --global user.email "$email"

        if [[ $(l.ask 'Confirm to set up git?' Y) == YES ]]; then
            break
        fi
    done
}

function set_default_shell() {
    local ans=$(l.ask "Current default shell is $SHELL. Do you want to change it?" N)
    if [[ $ans == YES ]]; then 
        local current_shells=$(cat /etc/shells)
        info "Current shells available: $current_shells"
        local custom_shell=$(l.ask_input "What shell do you want to use?" "/bin/bash")
        chsh -s $custom_shell
    fi
}
