fs   = require 'fs'
path = require 'path'

abort = false

class Library
  constructor: ->
    @modules = {}

  addModule: (path) ->
    mod = new Module path, @

  finishLoading: ->

class Module
  constructor: (@path, @library) ->
    @loadingStarted = false
    @dependencies = {}

    @loader = require @path

    if 'function' isnt typeof @loader
      @loader = -> @loader
      
    @attemptLoad()

  attemptLoad: ->
    loadResult = @loader @library.definitions

    if 'object' isnt (t = typeof loaderResult)
      throw new Error "module loader for #{@path} returned a #{t}: #{loadResult}"

    if (v = Object.values loaderResult).length and
        v.filter((e) -> e isnt undefined).length is 0
      @library.moduleRequest @, Object.keys loaderResult
    else
      @library.resolved loaderResult

#loadFile = (modulePath, reject, library) ->
#  try
#    loader = require modulePath
#
#    if 'function' isnt typeof loader
#      loader = -> loader
#
#    startLoadingModule modulePath, loader, reject, library
#
#  catch err
#    return reject err

loadDir = (dir, resolve, reject, library) ->
  fs.openDir dir, (err, entries) ->
    if err then return reject err

    for e in entries when not abort and not e.match /^[.]/
      there = path.resolve dir, e

      fs.stat there, (err, stat) ->
        if err then return reject err

        if stat.isDirectory()
          loadDir there, resolve, reject, library
          continue

        if not stat.isFile()
          continue

        loadFile there, resolve, reject, library


module.exports = ->
  here = path.dirname module.filename

  library = new Library

  loadDir here, library

  library.finishLoading()
