# Main zsh interactive shell configuration. ACTIVELY USED.
# Sourced in interactive shells only.

# It should contain commands to set up aliases, functions, options, key
# bindings, etc.

bindkey -v
export EDITOR=vim

# Fix the "do you wish to see all #### possibilities" issue when searching.
bindkey '\e/' history-incremental-pattern-search-backward

if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

  autoload -Uz compinit
  compinit
fi

eval "$(direnv hook zsh)"


# History Options
# ###############

setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS

export HISTFILESIZE=1000000
export HISTSIZE=2000
export SAVEHIST=100000

setopt INC_APPEND_HISTORY
export HISTTIMEFORMAT="[%F %T] "
setopt EXTENDED_HISTORY
setopt SHARE_HISTORY
setopt HIST_REDUCE_BLANKS


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

if [ -f ~/lib/shell/functions.sh ]; then
  . ~/lib/shell/functions.sh
fi

if [ -f ~/lib/shell/work.sh ]; then
  . ~/lib/shell/work.sh
fi


# Work Customizations
# ###################

if [ -f ~/.workrc ]; then
  . ~/.workrc
fi


# Prompt
# ######

# Load version control information
# autoload -Uz vcs_info
# precmd() { vcs_info }
# precmd_functions+=( precmd_vcs_info )
# setopt prompt_subst

# RPROMPT=\$vcs_info_msg_0_
# zstyle ':vcs_info:git:*' formats '%F{magenta}(%b)%f'
# zstyle ':vcs_info:*' enable git

PROMPT='%* %F{cyan}%5~%f %(?.%#.%F{red}%? %#)%f '

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Run once per day.
_daily_run_marker="$HOME/.cache/daily_run_$(date +%Y-%m-%d)"
if [[ ! -f "$_daily_run_marker" ]]; then
  mkdir -p "$HOME/.cache"
  touch "$_daily_run_marker"
  # Clean up previous day markers
  find "$HOME/.cache" -name 'daily_run_*' -not -name "daily_run_$(date +%Y-%m-%d)" -delete

  [ -f ~/bin/daily-lyric.sh ] && . ~/bin/daily-lyric.sh &

  (uv run /Users/mdaines/src/hebi/goodreads/goodreads_giveaways.py &>/dev/null &) 2>/dev/null
fi
unset _daily_run_marker

export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
export PATH="${HOME}/.local/bin:$PATH"
