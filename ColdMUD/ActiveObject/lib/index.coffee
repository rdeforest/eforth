# Main library loader
#
# NOTE: This module does not follow the usual Node module pattern. Its export
# is a function whose only parameter is a callback which is called with the AO
# namespace as its only parameter.

{resolve} =
path      = require 'path'

makeDebug = require 'debug'

debug     = makeDebug 'AO'
AO        = null

debug "dir: #{__dirname}, file: #{__filename}"

path.toNamespacedPath ?= (pathStr) ->
  pathStr.split path.sep

initMod   = (modName, dir = __dirname) ->
  debug "Attempting to initialize #{modName}"

  aoPath =
    ['AO'].concat (path.toNamespacedPath modName)
        .map (part) ->
          part[0].toUpperCase() +
          part[1..]
        .join '::'

  modPath = resolve dir, modName

  (require resolve modPath) AO, debug aoPath

module.exports = (callback) ->
  if not callback
    throw new Error "AO module requires a callback."

  if AO
    callback AO
    return

  {resolve}     = require 'path'
  {exit}        = require 'process'
  {promisify}   = require 'util'

  readdir       = promisify (require 'fs').readdir
  { namespace } = require resolve __dirname, 'namespace'
  { Namespace } = new require './namespace'
  AO            = Namespace 'AO'
  AO::Namespace = Namespace

  readdir __dirname
    .catch (err) ->
      console.log "Error searching #{resolve __dirname} for libraries: " +
        err.message + err.stack

    .then (entries) ->
      entries
        .filter (name) ->
          return false if name.startsWith '.'
          return false if resolve(__dirname, name) is __filename

          name.endsWith 'coffee'

        .forEach (name) ->
          initMod name

      callback AO
