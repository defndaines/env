#!/bin/sh
# Daily lyric URL opener. ACTIVELY USED. Sourced once per day from .zshrc.
# Opens the next URL from ~/bin/data/daily.dat (one per day, tracked by index).
# Requires: ~/bin/data/daily.dat (URLs), ~/bin/data/i (current index), ~/bin/data/d (last run date).
DATA=${HOME}/bin/data
i=$(cat "${DATA}/i")
last_ran=$(cat "${DATA}/d")
today=$(date +"%Y-%m-%d")
if [ "$last_ran" != "$today" ]; then
  open "$(head -"${i}" "${DATA}/daily.dat" | tail -1)"
  echo $((i + 1)) > "${DATA}/i"
  date +"%Y-%m-%d" > "${DATA}/d"
fi
