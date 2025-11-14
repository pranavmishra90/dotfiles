# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
####################################################################################

eval "$(zoxide init zsh)"


# Zsh completion
#-----------------------
fpath=($HOME/.zsh ~/yadm/zsh/zsh-autocomplete /usr/share/zsh/site-functions $fpath)

# Load the autocomplete plugin
# Note: This plugin automatically calls compinit
# Readme: https://github.com/marlonrichert/zsh-autocomplete#readme
source ~/yadm/zsh/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# Delay before showing suggestions (default is 0.05s)
zstyle ':autocomplete:*' delay 1.5

# Require a minimum # characters before showing suggestions
zstyle ':autocomplete:*' min-input 2

# Limit the number of suggestions to X
zstyle ':autocomplete:recent-paths:*' list-lines 10

# Enter key submits the command line even from within the menu
bindkey -M menuselect '\r' .accept-line

# Git completion
zstyle ':completion:*:*:git:*' script ~/yadm/scripts/completion/git-completion.zsh


# Key bindings
#-----------------------
# Bind keys for Home, End, and Delete

bindkey "^[[H" beginning-of-line    # Home key goes to the beginning of the line
bindkey "^[[F" end-of-line          # End key goes to the end of the line

# Use up and down arrow keys to navigate the history
bindkey -M emacs \
    "^[p"   .history-search-backward \
    "^[n"   .history-search-forward \
    "^P"    .up-line-or-history \
    "^[OA"  .up-line-or-history \
    "^[[A"  .up-line-or-history \
    "^N"    .down-line-or-history \
    "^[OB"  .down-line-or-history \
    "^[[B"  .down-line-or-history \
    "^R"    .history-incremental-search-backward \
    "^S"    .history-incremental-search-forward \
    #
bindkey -a \
    "^P"    .up-history \
    "^N"    .down-history \
    "k"     .up-line-or-history \
    "^[OA"  .up-line-or-history \
    "^[[A"  .up-line-or-history \
    "j"     .down-line-or-history \
    "^[OB"  .down-line-or-history \
    "^[[B"  .down-line-or-history \
    "/"     .vi-history-search-backward \
    "?"     .vi-history-search-forward \
    #
# Compatibility (alternates)
bindkey "^[[1~" beginning-of-line    # Home key goes to the beginning of the line
bindkey "^[[4~" end-of-line          # End key goes to the end of the line
bindkey "^[[3~" delete-char         # Delete key deletes the character under the cursor
bindkey "^[[5~" history-beginning-search-backward # Page Up
bindkey "^[[6~" history-beginning-search-forward  # Page Down

# Arrow keys in menuselect mode will move the cursor instead of selecting
# the next/previous item
bindkey -M menuselect  '^[[D' .backward-char  '^[OD' .backward-char
bindkey -M menuselect  '^[[C'  .forward-char  '^[OC'  .forward-char


# Argcomplete
if [ -f "/etc/bash_completion.d/python-argcomplete" ]; then
  . "/etc/bash_completion.d/python-argcomplete"
fi

if command -v datalad &>/dev/null; then
  eval "$(register-python-argcomplete datalad)"
fi

# Aliases 
#-----------------------
alias sourcezsh='source ~/.zshrc'
alias editzsh='nano ~/.zshrc'


source ~/.common_profile


#################################################
# MIT License                                   #
#                                               #
# Copyright © 2022-2025 Pranav Kumar Mishra     #
#################################################
