EventEmitter = require 'events'

class Watcher extends EventEmitter
  @makeHandler: (watcher, name, passThrough) ->
    (target, args...) ->
      watcher.emit name, {target, args}
      watcher.emit 'any', {name, target, args}
      passThrough target, args...

  @changeHandler: (watcher) ->
    handler = {}

    for name, fn of Object.getOwnPropertyDescriptors Reflect
      handler[name] = @makeHandler watcher, name, fn.value.bind Reflect

    handler
    
  constructor: (@target) ->
    @handler = Watcher.changeHandler @
    @proxy = new Proxy @target, @handler

Object.assign module.exports, {Watcher}
