#!/bin/bash

# Part of the yadm bootstrapping process
# Purpose: Place tmux config files in the expected location(s)

#------------------------------------------------------------------------------
# Initialization
#------------------------------------------------------------------------------

# Logger
#----------
# Report errors and exit if detected
trap 'logger ERROR "line $LINENO: $BASH_COMMAND"; exit 1' ERR
set -e

. "$HOME/yadm/functions/bash-logger.sh"

LOG_FILE="$HOME/.config/yadm/bootstrap.log"

create_log_file "$LOG_FILE"
logger INFO "Logging yadm bootstrap for tmux to: $LOG_FILE"



# Delete existing config files, if they exist
paths=( 
  "$HOME/.tmux.conf" 
  "$HOME/tmux.conf.local"
  "$HOME/.config/tmux/tmux.conf" 
  "$HOME/.config/tmux/tmux.conf.local"
)

for path in "${paths[@]}"; do
    # DEBUG 
    # echo "Checking for existing file or symlink at: $path"

    if [ -e "$path" ] || [ -L "$path" ]; then
        logger DEBUG "Removing existing file or symlink at: $path"
        rm -f "$path"
    fi
done


# Create both the traditional and XDG locations (point to your yadm files)
mkdir -p "$HOME/.config/tmux"

# When installing $XDG_CONFIG_HOME/tmux or ~/.config/tmux, the configuration file names don't have a leading . character.

ln -sfn "$HOME/yadm/tmux/tmux.conf"            "$HOME/.config/tmux/tmux.conf"
ln -sfn "$HOME/yadm/tmux/tmux.conf.local"      "$HOME/.config/tmux/tmux.conf.local"

# Debug: List the created files
logger DEBUG "Created tmux configuration symlinks: $(find "$HOME/.config/tmux" -name "tmux*" -type l -exec echo {} +)"