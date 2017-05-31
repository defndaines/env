# Various functions meant to be loaded by .bashrc

# Update only vim bundles
function vup() {
  echo "### Get latest pathogen"
  curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
  echo "### Updating vim bundles"
  bundles=(${HOME}/.vim/bundle/*)
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
