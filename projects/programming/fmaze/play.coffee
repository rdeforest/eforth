__ = require 'underscore'
global.app = require '.'

__.extend global, app.models

Promise.all(Node.create name: name = "n#{n}" for n in [1..4])
  .then (nodes) ->
    global[n.name] = n for n in nodes

    n1.connect n2, true

return global.app
