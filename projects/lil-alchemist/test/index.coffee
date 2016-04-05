fs = require 'fs'
path = require 'path'

thisDir = __dirname

# Should get this from whatever registration populates
knownExtensions = [
    'coffee'
    'js'
  ]

# TODO: Learn to use StrongLoop's logging
logLevel = 0

levels =
  skip: 0

maybeLog = (info) ->
  if info.level <= logLevel
    console.log info

note = (info) ->
  {what, which, why} = info
  info.level = levels[what] or 0
  maybeLog level, info

skipped = (info) ->
  info.what = 'skipped'
  note info

fs.readdir thisDir, (filesAndDirs) ->
  for fileOrDir in filesAndDirs
    if entry is 'index.coffee'
      skipped entry, "known meta-file"
    else if [matched, moduleName, extension] = entry.match /(.*)\.([^.]*)$/
      if extension in knownExtensions
        require path.join thisDir, moduleName
      else
        skipped entry, "unknown extension"
    else
      fs.stat fullPath, (stats) ->
        if stats.isDirectory()
          require path.join thisDir, entry
        else
          skipped entry, "no extension"
