fs            = require 'fs'
path          = require 'path'    ; path.toNamespacedPath ?= (pathStr) -> pathStr.split path.sep
util          = require 'util'

{ resolve
  basename }  = path

readdir       = util.promisify fs.readdir

debug         = (require 'debug') '::loader'

{ Namespace } = require './Namespace'

suffixes      = ''' coffee js json '''.split /\s+/

module.exports =
loadMod = (modPath, ns = basename modPath) ->
  debug "Loading #{modPath}"

  unless nsOrNsName instanceof Namespace
    ns = new Namespace ns

  if fs.statSync(modPath).isDirectory()
    return loadModDir modPath, ns

  Promise.resolve require modPath
    .then (module) -> ns.set module, module.name

loadMod.comment = """
  I 'load' a module by require()ing it into a namespace. I recurse through
  directories. If the provided namespace is a string, I create a namespace
  with the given name.

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

loadable = (name) ->
  return false if name.startsWith '.'

  for suffix in suffixes when name.endsWith suffix
    return true

  false

Object.assign loadModDir = (modPath, ns) ->
  readdir modPath
    .then (entries) ->
      Promise.all(
        entries
          .filter  loadable
          .forEach (mod) ->
            loadMod (resolve modPath, mod), ns
      )

    .catch (err) ->
      console.log "Error searching #{resolve modPath} for libraries: " +
        err.message + err.stack
