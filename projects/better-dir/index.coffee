DirReader = require 'native-readdir'

promisedFn = (fn) ->
  (args...) ->
    new Promise (resolve, reject) ->
      resolve fn args...

module.exports =
  mapDir = (path, fn) ->
    fn = promisedFn fn

    new Promise (resolve, reject) ->
      reader = new DirReader path

      results = []

      doAnother = ->
        reader.read (err, entry) ->
          if err
            return reject err

          if entry is null
            return resolve results

          fn entry
            .then (ret) ->
              results.push ret
              doAnother()

      reader.open (err) ->
        if err
          return reject err

        try
          doAnother()
        catch e
          reject e

###

Usage

  mapDir = require 'map-dir'

  scanner = (entry) ->
    # do something with entry

  map-dir '.', scanner
    .then (results) ->
      ...

###
