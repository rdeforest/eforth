{ abstract } = require './abstractClass'

virtualMethods = 'get put has ids'.split ' '

warned = {}

warn = (args...) ->
  unless warned args[0]
    console.warn args...
    warned[args[0]] = true

[ exports.Store ] = abstract Store: virtualMethods
  class Store
    init: (self, [@opts = {}]) ->
      warn "Class #{@constructor} has no .init"
