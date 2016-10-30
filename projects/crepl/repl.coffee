# Repl support

cs = require 'coffee-script'
fs = require 'fs'

defs = []

ourGlobal = null


parseName = (name, mustNotExist) ->
  tgt = ourGlobal
  didExist = true
  adjustedName = name
    .replace /^::/,   'prototype.' # technically not legal, but whatevs
    .replace  /::$/, '.prototype'
    .replace  /::/g, '.prototype.'

  [path..., memberName] = adjustedName.split '.'

  for part in path
    member = tgt[part]

    if not member
      if mustNotExist
        tgt[part] = {}
        didExist = false

    tgt = tgt[part]

  if mustNotExist and didExist
    return false

  [tgt, memberName]


_def = (fullName, src, [tgt, name]) ->
  fn = cs.eval "#{fullName} = #{src}"

  for d, idx in defs when d.fullName is fullName
    defs.splice idx, 1
    break

  defs.push {fullName, src}
  [tgt, name] = parseName fullName
  tgt[name] = fn
  save


def = (fullName, src) ->
  if isNew = parseName fullName, true
    console.log "#{fillName} already exists, use 'redef' to change it"
    return false

  _def fullName, src, isNew


redef = (fullName, src) ->
  _def fullName, src, parseName fullName


module.exports = (persistTo = 'defs.json', g = global) ->
  ourGlobal = g
  Object.assign ourGlobal, {def, defs, redef}

  load = ->
    saved = JSON.parse fs.readFileSync persistTo, 'utf-8'
    loop
      len = saved.length

      saved = saved.filter ({fullName, src}) ->
        try
          redef fullName, src
          false
        catch
          true

      if saved.length in [0, len]
        break

    saved.length is 0

  save = ->
    fs.writeFileSync persistTo, JSON.stringify defs, 0, 2

  Object.defineProperties ourGlobal,
    load:
      get: load
      set: (name) ->
        persistTo = name
        load
    save:
      get: save
      set: (name) ->
        persistTo = name
        save

  load persistTo

  if 'function' is typeof autorun
    autorun g

  console.log "Repl util loaded"
