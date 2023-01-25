!#/bin/bash

# Install dotfiles with yadm
yadm clone --recurse-submodules -f https://github.com/pranavmishra90/dotfiles

# Change timezone to Chicago
ls -l /etc/localtime
sudo ln -s /usr/share/zoneinfo/America/Chicago /etc/localtime
