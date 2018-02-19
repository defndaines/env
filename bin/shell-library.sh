#!/usr/local/bin/bash
# Various functions meant to be loaded by .bashrc

# Update only vim bundles
function vup() {
  echo "### Updating vim bundles"
  bundles=(${HOME}/.vim/pack/git-plugins/start/*)
  for bundle in "${bundles[@]}"; do
    pushd "$bundle"
    git pull
    popd
  done
}

function usage {
  echo "error: $*" 2>&1
  exit 1
}

# Back up an existing file.
function bak() {
  cp "$@"{,.bak}
}

# Securely create a temporary directory.
function tmpdir() {
  tmp=${TMPDIR-/tmp}
  tmp=$tmp/somedir.$RANDOM.$RANDOM.$RANDOM.$$
  (umask 077 && mkdir "$tmp") || {
    echo "Could not create temporary directory! Exiting." 1>&2 
    exit 1
  }
}

function psgrep {
  ps axuf | grep -v grep | grep "$@" -i --color=auto;
}

function fname {
  find . -iname "*$@*";
}

function lt {
  ls -targ "$@" | tail;
}

function eunit {
  proj=$@
  if [ -z "${proj}" ]; then
    d=$(pwd)
    proj=$(basename "$d" | sed 's/-/_/g')
  fi
  erl -make && erl -noshell -eval "eunit:test(${proj}, [verbose])" -s init stop
}

# Enable branch completion for `co` alias (git checkout).
_branches() {
  local cur branches modified
  cur="${COMP_WORDS[COMP_CWORD]}"
  branches=$(git branch --list)
  # NOTE: checkout -- isn't autocompleting to checked out files.
  # modified=$(git status --short)

  # if [[ ${prev} == '--' ]] ; then
    # COMPREPLY=( $(compgen -W "${modified}" -- ${cur}) )
    # return 0
  # else
    COMPREPLY=( $(compgen -W "${branches}" -- ${cur}) )
    return 0
  # fi
}
complete -F _branches co

_databases() {
  local cur dbs
  cur="${COMP_WORDS[COMP_CWORD]}"
  dbs=$(psql -l | cut -d\  -f2)

  COMPREPLY=( $(compgen -W "${dbs}" -- ${cur}) )
  return 0
}
complete -F _databases psql
