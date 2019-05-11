#!/usr/local/bin/bash
# Various functions meant to be loaded by .bashrc

# Update only vim bundles
function vup() {
  echo "### Updating vim bundles"
  bundles=(${HOME}/.vim/pack/bundle/start/*)
  for bundle in "${bundles[@]}"; do
    pushd "$bundle"
    git pull
    popd
  done
  if [ -d "${HOME}/.vim/pack/bundle/opt" ]; then
    bundles=(${HOME}/.vim/pack/bundle/opt/*)
    for bundle in "${bundles[@]}"; do
      pushd "$bundle"
      git pull
      popd
    done
  fi
}

function alert() {
  say -v Kyoko "終わったよ"
  say -v Moira "Well ... that went well."
  osascript -e 'tell application "Finder" to display dialog "DONE!"'
}

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

# Open a man page as a PDF in Preview
function postman() {
  man -t $1 | open -f -a Preview.app
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

## https://gist.github.com/brianloveswords/7534169715b5750a892cddcf54c2aa0e

video-url-from-tweet() {
  # Takes a tweet URL and returns the MP4 embedded in that tweet, or fails if
  # no video is found.
  if [ "$1" ]; then
    url=$1
  else
    echo "Must provide a url"
    return 1
  fi

  curl --silent $url |\
    # should find the <meta> tag with content="<thumbnail url>"
    (grep -m1 "tweet_video_thumb" ||\
      echo "Could not find video" && return 1) |\

    # from: <meta property="og:image" content="https://pbs.twimg.com/tweet_video_thumb/xxxxxxxxxx.jpg">
    # to: https://pbs.twimg.com/tweet_video_thumb/xxxxxxxxxx.jpg
    cut -d '"' -f 4 |\

    # from: https://pbs.twimg.com/tweet_video_thumb/xxxxxxxxxx.jpg
    # to: https://video.twimg.com/tweet_video/xxxxxxxxxx.mp4
    sed 's/.jpg/.mp4/g' |\
    sed 's/pbs.twimg.com\/tweet_video_thumb/video.twimg.com\/tweet_video/g'
}
video-from-tweet() {
  # Returns the raw data of the video that is embedded in the tweet.
  if [ "$1" ]; then
    url=$1
  else
    echo "Must provide a url"
    return 1
  fi
  curl $(video-url-from-tweet $url)
}
video-to-gif() {
  # Converts a video to a GIF.
  # Derived from https://engineering.giphy.com/how-to-make-gifs-with-ffmpeg/
  if [ "$2" ]; then
    input=$1
    output=$2
  else
    echo "Must provide an input file and output file"
    return 1
  fi

  ffmpeg -i $input \
    -filter_complex "[0:v] split [a][b];[a] palettegen [p];[b][p] paletteuse" \
    -f gif \
    $output
}
gif-from-tweet() {
  # Takes a tweet URL and an output filename and saves the MP4 embedded in that
  # tweet as a GIF.
  #
  # Example: gif-from-tweet https://twitter.com/tsunamino/status/1003318804619804672 wink.gif
  if [ "$2" ]; then
    url=$1
    output=$2
  else
    echo "Must provide a url and an output filename"
    return 1
  fi
  video-from-tweet $url | video-to-gif - $output
}
