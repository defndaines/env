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

HOMEBREW_PREFIX="$(brew --prefix)"
PATH="${HOMEBREW_PREFIX}/sbin:${HOMEBREW_PREFIX}/bin:$PATH"

# Prioritize RVM if installed
if [ -e "${HOME}/.rvm" ] ; then
  PATH="${HOME}/.rvm/bin:${PATH}"
elif [ -e "${HOMEBREW_PREFIX}/opt/ruby/bin" ] ; then
  PATH="${HOMEBREW_PREFIX}/opt/ruby/bin:$PATH"
fi

# psql and other PostgreSQL commands if no local DB installed
if [ -e "${HOMEBREW_PREFIX}/opt/libpq/bin" ] ; then
  PATH="${HOMEBREW_PREFIX}/opt/libpq/bin:$PATH"
fi

# vim-iced
if [ -e "${HOME}/.vim/pack/bundle/start/vim-iced/bin" ]; then
  PATH="$PATH:${HOME}/.vim/pack/bundle/start/vim-iced/bin"
fi

# GNU grep
if [ -e "${HOMEBREW_PREFIX}/opt/grep/libexec/gnubin" ]; then
  PATH="${HOMEBREW_PREFIX}/opt/grep/libexec/gnubin:$PATH"
fi

# Java
export JAVA_HOME=$(/usr/libexec/java_home);
export PATH=$JAVA_HOME/bin:$PATH

# Quiet warning about "Options -Xverify:none and -noverify were deprecated in JDK 13"
export LEIN_JVM_OPTS="-XX:TieredStopAtLevel=1"

# Lua
if [ -e "${HOMEBREW_PREFIX}/bin/luarocks" ]; then
  eval "$(luarocks path)"
fi

# Set PATH so it includes user's private bin if it exists
if [ -d "${HOME}/bin" ] ; then
  PATH=${HOME}/bin:${PATH}
fi

# Add escripts
if [ -d "${HOME}/.mix/escripts" ] ; then
  PATH=${HOME}/.mix/escripts:${PATH}
fi

# Clear out duplication in the PATH before exporting.
PATH="$(echo $PATH | perl -e 'print join(":", grep { not $seen{$_}++ } split(/:/, scalar <>))')"
export PATH

# Pretty output
export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx

# Prevent Homebrew from sending analytics
export HOMEBREW_NO_ANALYTICS=1

export GREP_OPTIONS='--color=auto'

# If using both fzf and rg.
if [ -x "$(command -v fzf)" ] ; then
  if [ -x "$(command -v rg)" ] ; then
    export FZF_DEFAULT_COMMAND='rg --files'
  fi
fi

# vim Options
export VIMCONFIG=~/.vim
export VIMDATA=~/.vim

# Enable Erlang/Elixir shell history
export ERL_AFLAGS="-kernel shell_history enabled"

# SRC_DIR
export SRC_DIR=${HOME}/src


# Work Customizations
# ###################

if [ -f ~/.workenv ]; then
  . ~/.workenv
fi
