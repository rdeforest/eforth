#!/bin/bash

shEnvCfgDir=$HOME/.config/shellEnv

if [ -e  $shEnvCfgDir/boot ]; then
  source $shEnvCfgDir/boot
else
  shEnvGreeting=".bashrc started..."
  shEnvLibDir="$HOME/.lib"
  shEnvTmp="$shEnvLibDir/.tmp"
fi

mkdir -p $shEnvTmp

#echo "$shEnvGreeting"

for module in $(ls -1 "$shEnvLibDir" | grep -E '^[0-9]+_'); do
  file="$shEnvLibDir/$module"

  if [ ! -d "$file" ]; then
    order=$(echo   "$module" | sed 's/^\([0-9]\{1,\}\)_.*/\1/')
    modName=$(echo "$module" | sed 's/^\([0-9]*\)_//')

    #echo  "  ($order) $modName"
    source "$file"
  fi
done

#echo "done"

# shouldn't be necessary, but whatever...
export NODE_PATH=/usr/local/lib/node_modules:.

# Yes, yes, I know...
export PATH=~/bin:$PATH
