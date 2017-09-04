#!/usr/bin/env coffee

# This has ZERO to do with plotting. I need to make this into a Yeoman generator.

runningAsMain = require.main is module

fs      = require 'fs'
path    = require 'path'
util    = require 'util'
process = require 'process'

process.on 'unhandledRejection', (reason, p) ->
  debug "Unhandled rejection at #{p}, reason: #{reason}\n#{reason.stack}"

[access, readdir] = [fs.access, fs.readdir].map util.promisify

debug   = (require 'debug') 'plot:main'

addPath = (dir) ->
  module.paths.push dir
  debug "Added #{dir} to require paths."
  return dir

addPath dir for dir in ['/usr/lib/node_modules', '/usr/local/lib/node_modules', libDir = path.resolve __dirname, 'lib']

# which = (execName) ->
#   where = null
# 
#   Promise.all(
#       for dir in process.env.PATH.split ':' when not where
#         do (dir) ->
#           access (found = path.resolve dir, execName), fs.constants.X_OK
#             .then  ->
#               where = found
#               debug "Found #{execName} at #{where}"
#             .catch -> # ignored, only care about success
#     ) .then -> where

module.exports = loadAll = (libDir) ->
  readdir libDir
    .then (entries) ->
      for entry in entries when not entry.startsWith '.'
        try
          mod = require entry

          if 'function' is typeof mod
            mod = "#{entry}": mod

          Object.assign exports, mod
    .catch (err) -> debug "Error scanning #{libDir}: #{err}"

if runningAsMain
  debug "Detected invoked as main, loading libs and starting repl"
  loadAll libDir
    .then ->
      Object.assign global, exports
      debug "  libs loaded"
      (require 'coffeescript/lib/coffeescript/command').run()
