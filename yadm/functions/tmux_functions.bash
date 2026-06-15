#!/bin/bash

# Tmux / Tmuxinator
#------------------------------------------------
function ktr() {
    printf "Do you want to kill the tmux session? [y/n] "
    read choice
    [[ "$choice" == "y" ]] && tmux kill-session
}