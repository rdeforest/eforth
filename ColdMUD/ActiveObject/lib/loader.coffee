fs            = require 'fs'
path          = require 'path'    ; path.toNamespacedPath ?= (pathStr) -> pathStr.split path.sep
util          = require 'util'

{ resolve }   = path
{ promisify } = util

readdir       = promisify fs.readdir

debug         = (require 'debug') '::loader'

{ Namespace } = require './namespace'

module.exports =
loadMod = (modPath) ->
  debug "Loading #{modPath}"

  nsName = path.basename modPath

  ns     = new Namespace nsName

  ( if fs.statSync(modPath).isDirectory()
      loadModDir
    else
      loadModFile
  ) ns, makeDebug

loadModFile = (ns, modPath) ->
  Promise.resolve (require resolve modPath) ns, makeDebug

loadModDir = (ns, modPath) ->
  modPathName = modPath

  readdir modPath
    .then (entries) ->
      nsRoot = new Namespace modPathName, nsRoot

      Promise.all(
        entries
          .filter  (name) -> (not name.startsWith '.') and name.endsWith 'coffee'
          .forEach (name) -> loadMod nsRoot, name
      )

    .catch (err) ->
      console.log "Error searching #{resolve modPath} for libraries: " +
        err.message + err.stack
