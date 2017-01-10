fs = require 'fs'
util = require './util'

module.exports =
  new Promise (resolve, reject) ->
    fs.readdir 'common/model', (err, files) ->
      return reject err if err

      for f in files

