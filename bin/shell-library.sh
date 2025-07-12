###
# Functions for the shell

# Update only vim bundles
vup() {
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
most-common() {
  sort "$@" | uniq -c | sort -n | tail
}

usage() {
  echo "error: $*" 2>&1
  exit 1
}

# Back up an existing file.
bak() {
  cp "$@"{,.bak}
}

# Securely create a temporary directory.
tmpdir() {
  tmp=${TMPDIR-/tmp}somedir.${RANDOM}.${RANDOM}.${RANDOM}.$$
  (umask 077 && mkdir "$tmp") || {
    echo "Could not create temporary directory! Exiting." 1>&2
    exit 1
  }
}

# Helper script for Wordle, https://www.nytimes.com/games/wordle/
#   Shows frequency of each letter present in passed file.
letters() {
  sed 's/./&\n/g' "$@" | grep -v "^$" | sort | uniq -c | sort -n
}

# Script for Spelling Bee puzzle, https://www.nytimes.com/puzzles/spelling-bee
#   Expects two arguments: the center letter and a string of all the optional letters
#   Creates /tmp/bee file will all possible words.
#   Outputs all the pangrams.
bee() {
  # Contains center letter, no proper nouns, and at least four letter words.
  grep "$1" /usr/share/dict/words | grep -v "^[A-Z]" | grep -v "^.\{1,3\}$" | grep "^[$1$2]*$" > /tmp/x
  # Eliminate "misspelled" words.
  comm -23 /tmp/x <(aspell list < /tmp/x) > /tmp/bee
  # Find all pangrams.
  bee="${1}${2}"
  eval array=\( '${bee:'{0..6}':1}' \)
  pangram=$(cat /tmp/bee)
  for l in "${array[@]}"; do
    pangram=$(grep "$l" <(echo $pangram))
  done
  echo $pangram
}

psgrep() {
  ps axuf | grep -v grep | grep "$@" -i --color=auto;
}

fname() {
  find . -iname "*$@*";
}

lt() {
  ls -targ "$@" | tail;
}

eunit() {
  proj=$@
  if [ -z "${proj}" ]; then
    d=$(pwd)
    proj=$(basename "$d" | sed 's/-/_/g')
  fi
  erl -make && erl -noshell -eval "eunit:test(${proj}, [verbose])" -s init stop
}

# Select a random line from a file.
rl() {
  sort --random-sort "$@" | head -1
}
