#!/bin/bash

# ~/.bashrc (bash) or ~/.zshrc (zsh) --> placing in .common_profile

# Reuse keychain agent environment if it exists
[ -f ~/.keychain/$HOSTNAME-sh ] && source ~/.keychain/$HOSTNAME-sh