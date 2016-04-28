fs = require 'fs'
path = require 'path'

read = (file...) ->
  file = path.resolve file...

  fs.readFileSync file

config = null

isObj = (o) -> o and 'object' is typeof o

module.exports = (dir) ->
  config or
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

      load: (configJSON) ->
        loading = JSON.parse configJSON
        
        for context, ctx of loading
          _.extend config.data[context], ctx

      serialize: ->
        JSON.stringify config.data

    for file in ['defaults', 'current']
      try
        config.load read dir, file
      catch e
        warn "Could not load config #{path.resolve dir, file}: #{e}"
