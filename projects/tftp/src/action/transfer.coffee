Action = require '.'
Key    = require '../key'

module.exports =
  class Transfer extends Action
    constructor: (keyString) ->
      if not keyString
        return new Help "Object location key was not provided."

      if not @key = new Key keyString
        return new Help "Object location key '#{keyString}' was not recognized."
