# ~/.bash_profile: executed by bash for login shells.

# source the system wide bashrc if it exists
if [ -e /etc/bash.bashrc ] ; then
  source /etc/bash.bashrc
fi

# source the users bashrc if it exists, but only for login
if shopt -q login_shell ; then
  if [ -e "${HOME}/.bashrc" ] ; then
    source "${HOME}/.bashrc"
  fi
fi

# OPAM configuration
if [ -e "${HOME}/.opam/opam-init/init.sh" ] ; then
  . ${HOME}/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
fi

# Set PATH so it includes user's private bin if it exists
if [ -d "${HOME}/bin" ] ; then
  PATH=${HOME}/bin:${PATH}
fi

# Bring in MySQL, if installed.
if [ -d /usr/local/opt/mysql/bin ]; then
  PATH=${PATH}:/usr/local/opt/mysql/bin
fi
# Check for mysql command-line client.
if [ -d /usr/local/opt/mysql-client/bin ]; then
  PATH="/usr/local/opt/mysql-client/bin:$PATH"
fi

# Add Python3 installed binaries to path
PATH=${PATH}:${HOME}/Library/Python/3.7/bin

# Add SQLite to PATH
PATH="/usr/local/opt/sqlite/bin:$PATH"

# Prioritize anything brewed in.
PATH="/usr/local/sbin:/usr/local/bin:$PATH"

# Prioritize RVM if installed
if [ -e "${HOME}/.rvm" ] ; then
  PATH="${HOME}/.rvm/bin:${PATH}"
elif [ -e /usr/local/opt/ruby/bin ] ; then
  PATH="/usr/local/opt/ruby/bin:$PATH"
fi

# vim-iced
if [ -e "${HOME}/.vim/pack/bundle/start/vim-iced/bin" ]; then
  PATH="$PATH:${HOME}/.vim/pack/bundle/start/vim-iced/bin"
fi

# GNU grep
if [ -e "/usr/local/opt/grep/libexec/gnubin" ]; then
  PATH="/usr/local/opt/grep/libexec/gnubin:$PATH"
fi

# Clear out duplication in the PATH before exporting.
PATH="$(echo $PATH | perl -e 'print join(":", grep { not $seen{$_}++ } split(/:/, scalar <>))')"
export PATH

# Pretty output
export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx

# Prevent Homebrew from sending analytics
export HOMEBREW_NO_ANALYTICS=1

# Allows for quicker switching between source code repositories.
# export CDPATH=${HOME}/src:${CDPATH}

# If using both fzf and rg.
if [ -x "$(command -v fzf)" ] ; then
  if [ -x "$(command -v rg)" ] ; then
    export FZF_DEFAULT_COMMAND='rg --files'
  fi
fi

# vim Options
export VIMCONFIG=~/.vim
export VIMDATA=~/.vim

# Bash prompt
export PS1="\h:\[\033[32m\]\W\[\033[33m\]\$(_current_branch)\[\033[00m\] $ "

# SRC_DIR
export SRC_DIR=${HOME}/src

# Quiet the lein warning about -Xverify:none is deprecated in JDK 13
export LEIN_JVM_OPTS="-XX:TieredStopAtLevel=1"
