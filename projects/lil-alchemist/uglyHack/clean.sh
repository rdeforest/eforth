#!/bin/bash

(
find -name '*Wikia' -print0
find -name '\?'     -print0 
find -name 'Combos' -print0
) | xargs -0 rm -v
