loadDir = (dir, resolve, reject, library) ->
  fs.openDir dir, (err, entries) ->
    if err then return reject err

    for e in entries when not abort
      fs.stat path.resolve(here, e), (err, stat) ->
        if err then return abort = err

        if stat.isDirectory()

    reject abort if abort
      

module.exports = ->
  new Promise (resolve, reject) ->
    fs   = require 'fs'
    path = require 'path'

    here  = path.dirname module.filename
    abort = false

    library =
      loading   : {}
      requested : {}
      resolved  : {}

