set -o vi
export EDITOR=vim
stty stop ''  # Prevent Ctrl-S from stopping the terminal.

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize


# Completion options
# ##################

if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
  complete -o default -o nospace -F _git g
fi

# Add SSH completion based upon .ssh/config
[ -e "${HOME}/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# Complete gulp commands
command -v gulp >/dev/null 2>&1 && eval "$(gulp --completion=bash)"


# History Options
# ###############

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# Don't put duplicate lines in the history.
export HISTCONTROL="ignoredups"

# Ignore some controlling instructions
export HISTIGNORE="[   ]*:&:bg:fg:exit"

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000


# Aliases
# #######

if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

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


###
# Debian stuff

if [ -f ~/.debianrc ]; then
  . ~/.debianrc
fi


###
# Mac OS X stuff

if [ -f ~/.osxrc ]; then
  . ~/.osxrc
fi


###
# Work customizations

if [ -f ~/.workrc ]; then
  . ~/.workrc
fi
