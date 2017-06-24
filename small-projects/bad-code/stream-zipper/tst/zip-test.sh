#!/bin/bash

if [ "$1" == -v ]; then
  verbose=echo
  shift
else
  verbose=false
fi

function emitItems() {
    for item in "$@"; do
      echo "\"$item\""
    done
}

$1 <(emitItems one two three) <(emitItems {1..3}) |(
  read first;  $verbose $first
  read second; $verbose $second
  read third;  $verbose $third

  [ "$first"  == '["one","1"]' ] &&
  [ "$second" == '["two","2"]' ] &&
  [ "$third"  == '["three","3"]' ] && echo "ok" || echo "fail"
)

