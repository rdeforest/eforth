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

