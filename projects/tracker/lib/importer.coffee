fs = require 'fs'

importer = module.exports =
  from:
    csv: (args) ->
      data =
        groups: {}
      
      stream = fs.create

      stream.on 'data', (data) ->
        
