#!/bin/bash

url=$(coffee -e "console.log (require 'url').parse(\"http://lil-alchemist.wikia.com/wiki/$1\").href")

wget -O- "$url" |
  hxpipe |
  perl learn.pl "$1"
