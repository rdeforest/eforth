#!/bin/bash

find cards/ -type f |
  sed 's/.*\///' |
  sort -u
