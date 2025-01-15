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
    local GIT_USER GIT_EMAIL confirm
    while true; do
        # ask for git username and email
        username=$(ask_input "What's your git username?")
        email=$(ask_input "What's your git email?")
        confirm=$(yes_or_no 'Confirm to set up git?' Y)
        # if confirmed, set up git
        if [[ $confirm == Y ]]; then
            echo "export GIT_USER=$username" >> "$DOTFILES_DIR"/.envrc
            echo "export GIT_EMAIL=$email" >> "$DOTFILES_DIR"/.envrc
            break
        else
            warn "Please try again."
        fi
    done
    mkdir -p "$DOTFILES_DIR"/git
    mo "$DOTFILES_DIR"/templates/git/config > "$DOTFILES_DIR"/git/config
}

function set_default_shell() {
    local answer all_shells selected_shell
    while true; do
        answer=$(yes_or_no "Current default shell is ${SHELL}. Do you want to change it?" N)
        if [[ $answer == N ]]; then
            break
        fi
        readarray -t all_shells < <(grep -v '^#' /etc/shells)
        info "Current all available shells:"
        selected_shell=$(choose "${all_shells[@]}")
        sudo chsh -s "$selected_shell"
    done
}

function set_config() {
    local config_dir shell_config_dir
    config_dir="$DOTFILES_DIR"/config
    shell_config_dir="$config_dir"/shell

    prepare_symlink "$config_dir" "$HOME/.config"

    local shells=(bash zsh)
    for shell in "${shells[@]}"; do
        local shell_dir="$shell_config_dir"/"${shell}"
        if [[ -d "$shell_dir" ]]; then
            for file in "$shell_dir"/*; do
                prepare_symlink "$file" "$HOME"/."$(basename $file)"
            done
        fi
    done
}
