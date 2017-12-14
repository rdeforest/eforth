# Main library loader
#
# NOTE: This module does not follow the usual Node module pattern. Its export
# is a function whose only parameter is a callback which is called with the AO
# namespace as its only parameter.

module.exports = (callback) ->
  if not callback
    throw new Error "Cannot init AO without a callback."

  {resolve}   = require 'path'
  {exit}      = require 'process'
  {promisify} = require 'util'
  readdir     = promisify (require 'fs').readdir

  new (require './namespace').Namespace 'AO'

  readdir __dirname,
    .catch (err) ->
      console.log "Error searching #{resolve __dirname} for libraries: " +
        err.message + err.stack
    .then (entries) ->
      entries
        .filter (name) ->
          return false if name.startsWith '.'
          return false if name is __filename

          name.endsWith 'coffee'
        .forEach (name) ->
          require resolve __dirname, name

      callback AO
