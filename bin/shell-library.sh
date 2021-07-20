###
# Functions for the shell

# Update only vim bundles
function vup() {
  echo "### Updating vim bundles"
  bundles=(${HOME}/.vim/pack/bundle/start/*)
  for bundle in "${bundles[@]}"; do
    pushd "$bundle"
    git pull
    popd
  done
  OPT_DIR=${HOME}/.vim/pack/bundle/opt
  if [[ $(ls -A $OPT_DIR) ]]; then
    bundles=(${OPT_DIR}/*)
    for bundle in "${bundles[@]}"; do
      pushd "$bundle"
      git pull
      popd
    done
  fi
}

# Pipe into this command for ten most common results with counts
function most-common {
  sort "$@" | uniq -c | sort -n | tail
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

# Select a random line from a file.
function rl {
  sort --random-sort "$@" | head -1
}
