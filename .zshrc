# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
####################################################################################

# PATH
#-----------------------
export PATH=$PATH:$HOME/.local/bin

# Aliases
#-----------------------
alias sourcezsh='source ~/.zshrc'
alias editzsh='nano ~/.zshrc'


alias ls="exa --icons --group-directories-first"
alias ll="exa --icons --group-directories-first -l"
alias g="goto"
alias grep='grep --color'

# Docker
alias dockerup='docker-compose up -d --remove-orphans && docker-compose ps && dtop'
alias dtop='docker ps -q | xargs  docker stats --no-stream'
alias logd='docker logs -tf --tail="200"'

# Rar
alias unrar-find='unrar e -r -o- *.rar ./'


# Git
#------------------
## Start SSH agent
eval $(ssh-agent -s)

alias pre-commit='python3 ~/git/pre-commit/pre-commit-2.20.0.pyz'


# GPG
#------------------
GPG_TTY=$(tty)
export GPG_TTY

############################################
# MIT License                              #
#                                          #
# Copyright © 2022 Pranav Kumar Mishra     #
############################################
