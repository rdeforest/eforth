#!/bin/bash

LASTSEEN="$(mktemp)"; trap "rm $LASTSEEN" EXIT
LOGDIR="."
FILEPAT="^test"
declare -A WATCHING

parser () {
  fileName="$1"
  lines="0"

  while read line; do
    (( lines++ ))
    echo "$fileName: $lines"
  done
}

inotifywait -m $LOGDIR | while read dir event file; do
  if [[ "$file" =~ $FILEPAT ]] && [[ -z "${WATCHING[${file}]}" ]]; then
    WATCHING[$file]=true
    ( tail -n 0 -f "$dir/$file" | parser "$dir/$file" )&
  fi
done

