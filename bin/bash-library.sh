#!/usr/local/bin/bash
# Various functions meant to be loaded by .bashrc

function _current_branch {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
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
