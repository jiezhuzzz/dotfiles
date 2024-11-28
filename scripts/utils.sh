#! /usr/bin/env bash

### shell options
set -e
set -u
set -o pipefail
(shopt -p inherit_errexit &>/dev/null) && shopt -s inherit_errexit

### public functions

# print functions
function status() {
    printf "\e[32m%s\e[0m\n" "$1"
}

function info() {
    printf "%s\n" "$1"
}

function warn() {
    printf "\e[33m%s\e[0m\n" "$1"
}

function error() {
    printf "\e[31m%s\e[0m\n" "$1"
    exit 1
}

# interactive functions
function ask_input() {
    local answer prompt
    local default=${2:-}
    if (($# < 2)); then
        prompt="${1:-Ask Input:} "
    else
        prompt="${1:-Ask Input:} (Default: $default) "
    fi

    read -rp "$prompt" answer
    printf '%s\n' "${answer:-$default}"
}

function yes_or_no() {
    local prompt=$1 default answer
    
    default=$(_yes_or_no_default "${2:-N}")
    
    while true; do
        read -rp "$prompt (Default: $default) " answer
        answer=${answer:-$default}
        
        answer=${answer,,}
        if [[ $answer == "yes" ]] || [[ $answer == "y" ]]; then
            printf '%s\n' "Yes"
            break
        elif [[ $answer == "no" ]] || [[ $answer == "n" ]]; then
            printf '%s\n' "No"
            break
        else
            warn "Invalid answer: $answer, please answer 'yes' or 'no'"
        fi
    done
}

function choose() {
    local items=("$@")

    local num prompt
    prompt=$(_choose_prompt)

    while true; do
        read -r -p "$prompt" num

        if ! [[ ${num} =~ ^[0-9]+$ ]]; then
            warn "Must enter an integer. Current: $num"
            continue
        fi

        if [[ $num -gt ${#items[@]} ]] || [[ $num -lt 1 ]]; then
            warn "Invalid choose number: $num"
            continue
        fi

        printf '%s\n' "${items[$((num - 1))]}"
        break
    done
}

# check functions
function has_cmd() {
    [[ $(which "$1") ]]
}

function array_has_value() {
    for item in "${@:2}"; do
        [[ $item == "$1" ]] && return 0
    done
    return 1
}

function has_sudo() {
    sudo -n true 2>/dev/null
}

function os() {
    uname | tr '[:upper:]' '[:lower:]'
}

function system_name() {
    if [[ $(os) == "darwin" ]]; then
        scutil --get LocalHostName
    else
        hostname
    fi
}

### internal functions

function _choose_prompt() {
    printf '  %s\n' 'No. Item'
    local i
    for i in "${!items[@]}"; do
        printf -- '- %-2d  %s\n' $((i + 1)) "${items[$i]}"
    done

    printf 'Please enter the number to choose: \n'
}

function _yes_or_no_default() {
    local default
    
    if [[ $1 == "Y" ]]; then
        default="Yes"
    elif [[ $1 == "N" ]]; then
        default="No"
    else
        error "Invalid default value: $default"
    fi

    printf '%s\n' "$default"
}
