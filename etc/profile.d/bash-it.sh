#!/bin/bash
# /etc/profile.d/bash-it.sh
# Activates system-wide bash-it if enabled by user

[ -z "$PS1" ] && return

if [ -f "$HOME/.bash_it/enable" ]; then
    # Ensure enabled directory exists
    mkdir -p "$HOME/.bash_it/enabled"
    export BASH_IT="/opt/bash-it"
    export BASH_IT_CUSTOM="$HOME/.bash_it/custom"
    export BASH_IT_THEME="${BASH_IT_THEME:-powerline-multiline}"

    # Ensure enabled directory exists
    mkdir -p "$HOME/.bash_it/enabled"

    if [ -f "$BASH_IT/bash_it.sh" ]; then
        source "$BASH_IT/bash_it.sh"
    fi
fi

