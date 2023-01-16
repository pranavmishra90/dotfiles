#Set the computer name here
eval server_name="Blackbox"
export GPG_TTY=$(tty)

#Bash Profile edits

export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/syno/sbin:/usr/syno/bin:/usr/local/sbin:/usr/local/bin:$PATH"


. /opt/etc/profile

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



#SSH

#Alias
alias editbash='nano ~/.bashrc'
alias sourcebash='source ~/.bashrc'

alias m4b-tool='docker run -it --rm -u $(id -u):$(id -g) -v "$(pwd)":/mnt sandreas/m4b-tool:latest'


alias mishracloud='cd /volume1/docker/MishraCloud'
alias cd-docker='cd /volume1/docker'
alias cd-complete='cd /volume1/Plex-Media/Import/in-progress/complete/'
alias cd-drishti='cd /volume1/docker/Drishti'
alias drishti-update='cd-drishti && docker-compose up -d'
alias drishti-minimal='cd-drishti && sh drishti-minimal.sh'
alias drishti-full='cd-drishti && sh drishti-full.sh'

alias plex-media='cd /volume1/Plex-Media'

alias cd-research='cd /volume1/Pranav/Research && ls -lh'

alias ll='ls -alF'

#Scripts
alias youtube-to-plex='sh /volume1/Scripts/plex-scripts/youtube-to-plex'

#Plex
alias stop-plex='synoservice -stop pkgctl-Plex\ Media\ Server'
alias start-plex='synoservice -start pkgctl-Plex\ Media\ Server'

#Programs
alias iperf3-start='docker run  -it --rm --name=iperf3 -p 5201:5201 networkstatic/iperf3 -s'
alias speedtest-run='python3 /volume1/Scripts/speedtest-cli/speedtest-cli'

alias unrar-find='unrar e -r -o- *.rar ./'

#NGINX

alias restart-nginx='sudo synoservice --restart nginx'

alias nginx-ports="sudo netstat -tulpn | grep LISTEN | grep 'nginx'"


# Script to change 443 and 80 port binding

#as root!
#sed -i -e 's/14080/80/' -e 's/14443/443/' /usr/syno/share/nginx/server.mustache /usr/syno/share/nginx/DSM.mustache /usr/syno/share/nginx/WWWService.mustache
#synoservicecfg --restart nginx


##Pranav
alias cd-pranav='cd /volume1/Pranav'
alias cd-programming='cd /volume1/Pranav/programming'

# PREPAREDx Ansible Playbook

alias cd-pdx='cd /volume1/Pranav/preparedx/preparedx-ansible'
alias pdx-ansible='cd-pdx && docker run -it --rm -w /work -v /volume1/Pranav/preparedx/preparedx-ansible:/work -v $HOME/.ssh/oracle/oracle:/root/.ssh/id_rsa:ro --entrypoint=/bin/sh docker.io/devture/ansible:2.9.14-r0'

###################
# Github
###################
## Add github ssh
eval $(ssh-agent -s)
ssh-add ~/.ssh/github/github



## Python
alias python='python3'

# Pre-commit
#---------------------

alias pre-commit='python3 /volume1/Installation/Synology/pre-commit/pre-commit-2.20.0.pyz'


# GPG
#------------------------
export GPG_TTY=$(tty)



###
source ~/.common_profile
