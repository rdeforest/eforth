# What if there were a class whose constructor returned a proxy which emits
# events when MOP-ish things happen?

EventEmitter = require 'events'

handler = new Proxy {},
  get: (target, property, receiver) ->
    if property in ['emitter', 'emit']
      return

    (realTarget, args...) ->
      return if emitting

      emitting = true

      realTarget
        .emitter
        .emit 'mopEvent', property, realTarget, args...

      emitting = false

module.exports.mixinMOPEmitter =
mixinMOPEmitter = (target) ->
  Object.defineProperty target, 'emitter',
    value: new Proxy target, handler
    enumerable: false

module.exports.MOPEventEmitter =
class MOPEventEmitter
  constructor: ->
    super

    mixinMOPEmitter @

module.exports.proxyThroughCallback = (target, cb) ->
  hProxy = new Proxy {},
    get: (target, property, receiver) ->
      (args...) ->
        cb {target, property, args}

  new Proxy target, hProxy
