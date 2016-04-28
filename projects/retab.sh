#!/bin/sh

retab="-n 1 echo"

case "$1" in
  -y ) 
    retab="perl -i -pe 's/^\t+/\"  \" x length($&)/e'"
    shift
esac

find "$@" -type f -print0 |
  xargs -0 $retab
