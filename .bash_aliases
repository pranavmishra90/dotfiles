
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
alias zsh='exec zsh'

alias editbash='nano ~/.bash_aliases'
alias sourcebash='source ~/.bashrc'

source ~/.common_profile
