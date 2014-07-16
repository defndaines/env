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

# Set PATH so it includes user's private bin if it exists
if [ -d "${HOME}/bin" ] ; then
  PATH=${HOME}/bin:${PATH}
fi

[[ -s "${HOME}/.rvm/scripts/rvm" ]] && . "${HOME}/.rvm/scripts/rvm"

export PATH

# OPAM configuration
. ${HOME}/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
