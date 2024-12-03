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
        if [[ $answer == "yes" || $answer == "y" ]]; then
            printf '%s\n' "Y"
            break
        elif [[ $answer == "no" || $answer == "n" ]]; then
            printf '%s\n' "N"
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
    command -v "$1" &>/dev/null
}

function array_has_value() {
    if (( $# < 2 )); then
        error "array_has_value: requires at least 2 arguments (value and array elements)"
    fi
    
    local needle=$1
    for item in "${@:2}"; do
        [[ $item == "$needle" ]] && return 0
    done
    return 1
}

function has_sudo() {
    sudo -l &>/dev/null
}

# system functions
function os() {
    # if darwin, return macos
    local name=$(uname)
    if [[ $name == "Darwin" ]]; then
        printf 'macos\n'
    elif [[ $name == "Linux" ]]; then
        printf 'linux\n'
    else
        error "Unsupported OS: $name"
    fi
}

function system_name() {
    if [[ $(os) == "darwin" ]]; then
        scutil --get LocalHostName
    else
        hostname
    fi
}

function prepare_dir() {
    if [[ ! -d "$1" ]]; then
        mkdir -p "$1"
    fi
}

function prepare_symlink() {
    if [[ ! -e "$1" ]]; then
        error "Source file $1 does not exist."
    fi
    if [[ -L "$2" ]]; then
        rm -f "$2"
    elif [[ -e "$2" ]]; then
        mv -f "$2" "$2".old
    fi
    ln -s "$1" "$2"
}

function relative_path() {
    local from=$1 to=$2

    local result=''

    while [[ "${to#"$from"}" == "$to" ]]; do
        if [[ $from == '.' ]]; then
            break
        fi

        from=$(dirname "$from")
        if [[ -z $result ]]; then
            result="../"
        else
            result="../$result"
        fi
    done

    forward_part="${to#"$from"}"
    forward_part="${forward_part#/}" # remove head slash

    if [[ -n $result ]]; then
        result="$result$forward_part"
    else
        result="${forward_part}"
    fi

    echo "${result%/}" # remove tail slash
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
