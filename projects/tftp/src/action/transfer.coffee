Action = require '.'
Key    = require '../key'

module.exports =
  class Transfer extends Action
    constructor: (@key) ->
      if not @key
        throw new Error "new #{@constructor.name} requires blob location key"
