#!/bin/bash

# Sourced by ~/.bash_profile (bash) or ~/.zprofile (zsh)

# Initialize keychain for login shells
if command -v keychain &>/dev/null; then
    eval $(keychain --eval --agents ssh id_ed25519)
fi