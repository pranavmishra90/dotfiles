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

# Miniconda
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/pranav/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/pranav/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/home/pranav/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/home/pranav/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<




export GPG_TTY=$(tty)
eval "$(zoxide init zsh)"



# Key bindings
#-----------------------
# Bind keys for Home, End, and Delete
bindkey "^[[H" beginning-of-line    # Home key
bindkey "^[[F" end-of-line          # End key
bindkey "^[[3~" delete-char         # Delete key

# PATH
#-----------------------
export PATH=$PATH:$HOME/.local/bin:$HOME/.local/lib/python3.8/


alias sourcezsh='source ~/.zshrc'
alias editzsh='nano ~/.zshrc'


source ~/.common_profile


#################################################
# MIT License                                   #
#                                               #
# Copyright © 2022-2024 Pranav Kumar Mishra     #
#################################################

