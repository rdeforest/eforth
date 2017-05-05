###

Streams can be annoying to setup, but I want to operate on directory entries
one at a time instead of reading the entire directory into memory first. This
module could help?

Usage:

    {mapDir, dirIterator} = require '.'
    fs = require 'fs'

    scanner = (dentry, resolve, reject, skip) ->
      # do something with dentry
      # - if you want it returned by .then, resolve it
      # - if you do not want to include the entry, skip()
      # - if you want to abort scanning reject with an error

    scanner.removeEmptyFiles = (dentry, resolve, reject, skip, dirpath) ->
      fs.lstat fullPath = (fs.resolve dirpath, dentry), (err, stat) ->
        if err then return reject err

        if stat.isFile() and stat.size is 0
          fs.unlink fullPath, (err) ->
            if err then reject err else skip()

    removeEmpty = (path) ->
      mapDir path, scanner.removeEmptyFiles
        .then -> console.log 'done'
        .catch (e) -> console.log e

Also available in New Iterator Style:

    dirIterator somePath
      .then (it) ->
        for entry from it
          # ...

###

DirReader = require 'native-readdir'

# Generator sync
#
# 'yield' is resumed by give.next 'value'
# 
# makeProducer = (give) -> -> asyncThing().then (value) -> give.next value
# 
# consumer = (producer) ->
#   loop
#     if not given = yield producer()
#       break
# 
# give = consumer makeProducer give
# give.next()
# 
# Now to improve the interface...

asyncIterator = (promiseMaker) ->
  producer = (give) -> -> promiseMaker().then (value) -> give.next value

  blocker = do -> yield producer()

  loop
    break unless given = yield blocker.next()

module.exports =
  mapDir: mapDir = (path, fn) ->
    new Promise (resolve, reject) ->
      reader = new DirReader path

      results = []

      nextEntry = ->
        reader.read (err, entry) ->
          if err
            return reject err

          if entry is null
            return resolve results

          addResult = (r = entry) ->
            results.push r
            nextEntry()

          fn entry, addResult, reject, nextEntry

      reader.open (err) ->
        if err
          return reject err

        try
          nextEntry()
        catch e
          reject e

  dirIterator: (path) ->
    new Promise (resolve, reject) ->
      reader = new DirReader path

      reader.open (err) ->
        if err then throw err

        resolve asyncGenerator ->
          new Promise (resolve, reject) ->
            reader.read (err, entry) ->
              if err
                reject err
              else
                resolve entry


###

Notes

'yield' ~= suspend()
'gen.next()' ~= resume()

###
