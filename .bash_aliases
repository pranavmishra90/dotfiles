#Set the computer name here
eval server_name="WSL-Pranav-Surface"


# Join Message
echo -e "\e[1;31m$server_name\e[0m"

# Set Windows Terminal Tab Name
echo -ne "\033]0;$server_name\a"


# Bash Formatting
function color_my_prompt {
    local __user_and_host="\[\033[01;32m\]\u:"
    local __cur_location="\[\033[01;34m\]\W"
    local __git_branch_color="\[\033[31m\]"
    #local __git_branch="\`ruby -e \"print (%x{git branch 2> /dev/null}.grep(/^\*/).first || '').gsub(/^\* (.+)$/, '(\1) ')\"\`"
    local __git_branch='`git branch 2> /dev/null | grep -e ^* | sed -E  s/^\\\\\*\ \(.+\)$/\(\\\\\1\)\ /`'
    local __last_color="\[\033[00m\]:"
    export PS1="$__user_and_host $__cur_location $__git_branch_color$__git_branch$__prompt_tail$__last_color "
}

color_my_prompt


# PATH
export PATH=/home/pranav/.local/bin:$PATH


# Alias Bash
#----------------

alias editbash='nano ~/.bash_aliases'
alias sourcebash='source ~/.bashrc'

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
