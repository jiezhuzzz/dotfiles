#! /usr/bin/env bash

### shell options
set -e
set -u
set -o pipefail
(shopt -p inherit_errexit &>/dev/null) && shopt -s inherit_errexit

function set_git() {
    # If git is already set up, skip
    if [[ -n $(git config --global user.name) ]]; then
        return
    fi
    # Ask for git username and email
    local username email confirm
    while true; do
        # ask for git username and email
        username=$(ask_input "What's your git username?")
        email=$(ask_input "What's your git email?")
        confirm=$(ask 'Confirm to set up git?' Y)
        # if confirmed, set up git
        if [[ $confirm == YES ]]; then
            git config --global user.name "$username"
            git config --global user.email "$email"
            break
        fi
    done
}

function set_shell() {
    local answer all_shells selected_shell
    while true; do
        answer=$(yes_or_no "Current default shell is ${SHELL}. Do you want to change it?" N)
        if [[ $answer == No ]]; then
            break
        fi
        readarray -t all_shells < <(grep -v '^#' /etc/shells)
        info "Current all available shells:"
        selected_shell=$(choose "${all_shells[@]}")
        sudo chsh -s "$selected_shell"
    done
}
