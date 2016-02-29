#!/bin/bash

grep -Rv " Hour" cards |
  sed 's/.*\///' |
  awk -F: '{print $1; print $2}' |
  sed 's/ /_/g' |
  sort -u

#find cards/ -type f |
#  sed 's/.*\///' |
#  sort -u
