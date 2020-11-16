# Sourced in interactive shells only.

# It should contain commands to set up aliases, functions, options, key
# bindings, etc.

set -o vi
export EDITOR=vim


# Git Completion
zstyle ':completion:*:*:git:*' script /usr/local/opt/git/share/zsh/site-functions/git-completion.bash
fpath=(/usr/local/opt/git/share/zsh/site-functions $fpath)

autoload -Uz compinit && compinit


# History Options
# ###############

setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_DUPS

export HISTSIZE=2000
export SAVEHIST=1500


# Aliases
# #######

if [ -f ~/.osx_aliases ]; then
  . ~/.osx_aliases
fi

if [ -f ~/.work_aliases ]; then
  . ~/.work_aliases
fi


# Functions
# #########

if [ -f ~/bin/shell-library.sh ]; then
  . ~/bin/shell-library.sh
fi

if [ -f ~/bin/work-library.sh ]; then
  . ~/bin/work-library.sh
fi


# Work Customizations
# ###################

if [ -f ~/.workrc ]; then
  . ~/.workrc
fi


# Prompt
# ######

# Load version control information
autoload -Uz vcs_info
precmd() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst

RPROMPT=\$vcs_info_msg_0_
zstyle ':vcs_info:git:*' formats '%F{magenta}(%b)%f'
zstyle ':vcs_info:*' enable git
 
PROMPT='%* %F{cyan}%2~%f %(?.%#.%F{red}%? %#)%f '