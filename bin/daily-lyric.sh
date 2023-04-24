#!/bin/bash
DATA=${HOME}/bin/data
i=$(cat "${DATA}/i")
last_ran=$(cat "${DATA}/d")
today=$(date +"%Y-%m-%d")
if [ "$last_ran" != "$today" ]; then
  open "$(head -"${i}" "${DATA}/daily.dat" | tail -1)"
  echo $((i + 1)) > "${DATA}/i"
  date +"%Y-%m-%d" > "${DATA}/d"
fi
