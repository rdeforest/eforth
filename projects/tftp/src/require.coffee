EventEmitter = require 'events'

class RequireWrapper extends EventEmitter
  

module.exports = (listener, fakeRequire = require) ->
  wrapper = (path) ->
    listener.emit 'requested', path

    if wrapper.override

    module = fakeRequire path

    if path.startsWith './'
      module fakeRequire
    else
      module
