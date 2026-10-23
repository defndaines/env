# Main zsh interactive shell configuration. ACTIVELY USED.
# Sourced in interactive shells only.

# It should contain commands to set up aliases, functions, options, key
# bindings, etc.

bindkey -v
export EDITOR=vim

# Pretty output
export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
alias grep='grep --color=auto'

# Enable Erlang/Elixir shell history
export ERL_AFLAGS="-kernel shell_history enabled"

# If using both fzf and rg.
if (( $+commands[fzf] && $+commands[rg] )); then
  export FZF_DEFAULT_COMMAND='rg --files'
fi

# Lua rocks. `luarocks path` is slow (~0.2s), so cache the LUA_PATH and
# LUA_CPATH it prints, keyed on the resolved luarocks binary so a brew upgrade
# regenerates it.
_luarocks_bin="${HOMEBREW_PREFIX}/bin/luarocks"
if [ -x "$_luarocks_bin" ]; then
  _luarocks_cache="$HOME/.cache/luarocks-path.zsh"
  _luarocks_key="# ${_luarocks_bin:A}"
  [ -f "$_luarocks_cache" ] && read -r _luarocks_cached_key < "$_luarocks_cache"
  if [[ "$_luarocks_cached_key" != "$_luarocks_key" ]]; then
    mkdir -p "$HOME/.cache"
    { print -r -- "$_luarocks_key"; "$_luarocks_bin" path | grep -E '^export LUA_C?PATH='; } > "$_luarocks_cache"
  fi
  . "$_luarocks_cache"
  unset _luarocks_cache _luarocks_key _luarocks_cached_key
fi
unset _luarocks_bin

# Fix the "do you wish to see all #### possibilities" issue when searching.
bindkey '\e/' history-incremental-pattern-search-backward

if type brew &>/dev/null
then
  FPATH="${HOMEBREW_PREFIX}/share/zsh/site-functions:${FPATH}"
fi

# Docker CLI completions.
fpath=(/Users/mdaines/.docker/completions $fpath)

# Run compinit once, after every fpath addition. Rebuild the completion dump at
# most daily; otherwise trust it (-C skips the slow security audit and rescan).
autoload -Uz compinit
() {
  setopt local_options extended_glob
  if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
    compinit
  else
    compinit -C
  fi
}

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

  nohup uv run /Users/mdaines/src/hebi/goodreads/goodreads_giveaways.py &>/dev/null &
  nohup uv run /Users/mdaines/src/hebi/storygraph/storygraph_giveaways.py &>/dev/null &
  nohup uv run /Users/mdaines/src/hebi/village_well/village_well_events.py &>/dev/null &
fi
unset _daily_run_marker

export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
export PATH="${HOME}/.local/bin:$PATH"
typeset -U path
