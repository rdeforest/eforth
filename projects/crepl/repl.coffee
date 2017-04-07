# Repl support

cs = require 'coffee-script'
fs = require 'fs'

defs = []

ourGlobal = null

makeHandlerMethod = (real, methodName = real.name) ->
  (target, args...) ->
    ret = real args...
    @saveChange methodName, target, args...


class Persister
  @defaultHandler:
    defineProperty: makeHandlerMethod Object.defineProperty
    deleteProperty: makeHandlerMethod Object.deleteProperty
    setPrototypeOf: makeHandlerMethod Object.setPrototypeOf
    set:
      makeHandlerMethod set = (target, prop, value, receiver) ->
        if receiver is target
          target[prop] = value

  constructor: (@cfg) ->
    @proxied = new Map
    @handler = Persister.defaultHandler
    @symbols = {}
    @nextSymId = 0

  idSymbol: (sym) ->
    @symbols[sym] ?= @nextSymId++

  propNames: (target) ->
    Object
      .getOwnPropertyNames(target)
      .concat Object.getOwnPropertySymbols target

  save: (target, args...) ->
    proto = Object.getPrototypeOf target
    ctor = target.contructor
    props = {}
    methods = {}

    for name in @propNames
      desc = Object.getOwnPropertyDescriptor target, name
      desc.sname = @serialize propName name

      if 'function' is typeof desc.value
        methods[name] = @serializeMethod desc
      else
        props[name] = @serializeProperty desc

    @write @proxied[target].file, JSON.stringify {
      ctor, proto, props, methods
    }

  create: (klass, args...) ->
    target = new klass args...
    proxy = new Proxy (), @handler
    file = @assignFileName info = {target, proxy, @handler, file}
    @proxied.set target, info
    proxy

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
