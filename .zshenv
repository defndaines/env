# Sourced on all invocations of the shell.

# It often contains exported variables that should be available to other
# programs. For example, $PATH.

export PATH="/usr/local/opt/postgresql@9.6/bin:$PATH"

# Add SQLite to PATH
PATH="/usr/local/opt/sqlite/bin:$PATH"

# Prioritize anything brewed in.
PATH="/usr/local/sbin:/usr/local/bin:$PATH"

# Add SQLite to PATH
PATH="/usr/local/opt/sqlite/bin:$PATH"

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

export JAVA_HOME=$(/usr/libexec/java_home);

export PATH=$JAVA_HOME/bin:$PATH

# Set PATH so it includes user's private bin if it exists
if [ -d "${HOME}/bin" ] ; then
  PATH=${HOME}/bin:${PATH}
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

# SRC_DIR
export SRC_DIR=${HOME}/src
