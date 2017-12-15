fs            = require 'fs'
path          = require 'path'    ; path.toNamespacedPath ?= (pathStr) -> pathStr.split path.sep
util          = require 'util'

{ resolve
  basename }  = path

readdir       = util.promisify fs.readdir

debug         = (require 'debug') '::loader'

{ Namespace } = require './Namespace'
{ qw }        = require './shared'

SUFFIXES      = qw ' .coffee .litcoffee .js .json '

module.exports =
loadMod = (modPath, ns) ->
  debug "Loading #{modPath} into #{ns?.name or ns or basename modPath}}"

  if fs.statSync(modPath).isDirectory()
    loadModDir modPath, ns
  else
    Promise.resolve require modPath
      .then (module) ->
        if ns instanceof Namespace
          ns.set module, basename modPath

loadable = (name) ->
  return false if name.startsWith '.'

  return -1 isnt SUFFIXES.find (suffix) -> name.endsWith suffix

# The provided 'ns' is the _parent_ namespace the directory contents are to be
# loaded into.
loadModDir = (modPath, ns) ->
  debug "scanning #{modPath}"

  readdir modPath
    .then (entries) ->
      debug "found #{entries.join ", "}"

      Promise.all(
        entries
          .filter  loadable
          .forEach (mod) ->
            loadMod (resolve modPath, mod), ns
      )

    .catch (err) ->
      console.log msg = "Error searching #{resolve modPath} for libraries: " + err.message + err.stack
      debug msg

loadMod.comment = """
  I 'load' a module by require()ing it into a namespace, if such is provided.
  I recurse through directories.

  Given a directory tree like

    root/
      branch/
        leaf.coffee
      leaf.coffee

  I will return a namespace named 'root',
  containing root::leaf and root::branch::leaf.

  index files are not given special treatment.

  I return a Promise whose .then provides the root namespace.
"""


