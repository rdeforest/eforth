comment = """
My children represent the structure and behavior of an AO model.
"""

{ EventEmitter } = require 'events'

{ ASchema } = require './schema'

exports.AO = AModel: class AModel extends EventEmitter
  @comment: comment
  constructor: (@parent = null) ->
    @symbol = Symbol()
    @schema = new ASchema

