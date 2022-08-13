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
export PATH=$PATH:$HOME/.local/bin:$HOME/.local/lib/python3.8/


alias sourcezsh='source ~/.zshrc'
alias editzsh='nano ~/.zshrc'


source ~/.common_profile

############################################
# MIT License                              #
#                                          #
# Copyright © 2022 Pranav Kumar Mishra     #
############################################
