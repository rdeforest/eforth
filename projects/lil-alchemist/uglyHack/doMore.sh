#!/bin/bash

sleep=

./known.sh | while read card; do
  if [ ! -e cards/"$card" ]; then
    echo "Fetching $card"
    $sleep
    ./docard.sh "$card"
    sleep="sleep 2"
  fi
done

