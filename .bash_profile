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
if [ -e ${HOME}/.opam/opam-init/init.sh ] ; then
  . ${HOME}/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
fi

# Set PATH so it includes user's private bin if it exists
if [ -d "${HOME}/bin" ] ; then
  PATH=${HOME}/bin:${PATH}
fi

# Bring in MySQL installation.
if [ -d /usr/local/mysql/bin ]; then
  PATH=${PATH}:/usr/local/mysql/bin
fi

# Add Python3 installed binaries to path
PATH=${PATH}:${HOME}/Library/Python/3.6/bin

# Prioritize anything brewed in.
PATH="/usr/local/sbin:/usr/local/bin:$PATH"

# Prioritize RVM if installed
if [ -e ${HOME}/.rvm ] ; then
  PATH="${HOME}/.rvm/bin:${PATH}"
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
export CDPATH=${HOME}/src:${CDPATH}
