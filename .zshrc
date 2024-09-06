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
export GPG_TTY=$(tty)
eval "$(zoxide init zsh)"



# Key bindings
#-----------------------
# Move to the beginning of the line
bindkey '^[[1~' beginning-of-line

# Move to the end of the line
bindkey '^[[4~' end-of-line


# PATH
#-----------------------
export PATH=$PATH:$HOME/.local/bin:$HOME/.local/lib/python3.8/


alias sourcezsh='source ~/.zshrc'
alias editzsh='nano ~/.zshrc'


source ~/.common_profile


# SSH-Agent
# ---------------
if [ -z "$SSH_AUTH_SOCK" ]; then
   # Check for a currently running instance of the agent
   RUNNING_AGENT="`ps -ax | grep 'ssh-agent -s' | grep -v grep | wc -l | tr -d '[:space:]'`"
   if [ "$RUNNING_AGENT" = "0" ]; then
        # Launch a new instance of the agent
        ssh-agent -s &> $HOME/.ssh/ssh-agent
   fi
   eval `cat $HOME/.ssh/ssh-agent`
fi


############################################
# MIT License                              #
#                                          #
# Copyright © 2022 Pranav Kumar Mishra     #
############################################

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

