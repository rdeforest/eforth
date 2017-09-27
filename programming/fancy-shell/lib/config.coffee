fs = require 'fs'
path = require 'path'
process = require 'process'

debug = (where, args, what..., fn) ->
  console.log "config##{where}(#{args.join ', '}):", what...
  ret = fn()
  console.log "done"
  ret

write = (string, file...) ->
  file = path.resolve file...

  console.log 'writing to ' + file

  fs.writeFileSync file, string

read = (file...) ->
  file = path.resolve file...

  fs.readFileSync file

decompose = (path) ->
  paths = [path]

  while path isnt parent = path.resolve p, '..'
    paths.unshift path = parent

  paths

isDir = (path) ->
  debug 'isDir', [path], ->
    paths = decompose path

    not paths.find (p) ->
      stat = fs.statSync p
      not stat.isDirectory()

deduceConfigDir = ->
  paths = [
      [process.env.FSH or '.', 'config']
      [process.env.HOME, '.fsh', 'config']
    ]

  paths = paths.map (p) -> path.resolve p...
  pick = paths.some (p) -> isDir p

  return pick or
    throw new Error "Couldn't deduce config dir"

configs = {}

isObj = (o) -> o and 'object' is typeof o

module.exports = (dir) ->
  if not dir
    dir = deduceConfigDir()

  if config = configs[dir]
    return config

  config =
    data:
      global: {}

    get: (context, key) ->
      if not isObj ctx = config.data[context]
        ctx = config.data.global
      ctx[key]

    set: (context, key, value) ->
      if not context
        context = config.data.global
      else
        context = config.data[context] or= {}

      context[key] = value

    save: ->
      write config.serialize(), dir, 'current.json'

    load: (configJSON) ->
      loading = JSON.parse configJSON
      
      for context, ctx of loading
        _.extend config.data[context], ctx

    serialize: ->
      JSON.stringify config.data

    dump: (format) ->
      # Currently ignoring 'format' because there is only one. Bleah.
      dump = ''

      for name, context of config.data
        for k, v of context
          dump += "fsh_#{name}_#{k}=#{JSON.stringify v}\n"

      dump

  for file in ['defaults', 'current']
    try
      config.load read dir, file
    catch e
      console.log "Could not load config #{path.resolve dir, file}: #{e}"

  return config
