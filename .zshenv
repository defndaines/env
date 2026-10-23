# Zsh environment file. ACTIVELY USED.
# Sourced on all invocations of the shell.

# It often contains exported variables that should be available to other
# programs. For example, $PATH.

# Prioritize anything brewed in.
if [ -e "/usr/local/bin" ] ; then
  PATH="/usr/local/bin:$PATH"
fi
if [ -e "/opt/homebrew/bin" ] ; then
  PATH="/opt/homebrew/bin:$PATH"
fi

# Avoids forking `brew --prefix` on every shell. Login shells also get this from
# `brew shellenv` in .zprofile.
HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-/opt/homebrew}"
PATH="${HOMEBREW_PREFIX}/sbin:${HOMEBREW_PREFIX}/bin:$PATH"

# GNU grep
if [ -e "${HOMEBREW_PREFIX}/opt/grep/libexec/gnubin" ]; then
  PATH="${HOMEBREW_PREFIX}/opt/grep/libexec/gnubin:$PATH"
fi

# Set PATH so it includes user’s private bin if it exists
if [ -d "${HOME}/bin" ] ; then
  PATH=${HOME}/bin:${PATH}
fi

# Clear out duplication in the PATH before exporting.
typeset -U path
export PATH

# Prevent Homebrew from sending analytics
export HOMEBREW_NO_ANALYTICS=1

# vim Options
export VIMCONFIG=~/.vim
export VIMDATA=~/.vim

# SRC_DIR
export SRC_DIR=${HOME}/src


# Work Customizations
# ###################

if [ -f ~/.workenv ]; then
  . ~/.workenv
fi
