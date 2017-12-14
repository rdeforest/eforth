debug = (require 'debug') 'AO.ASchema'

{ EventEmitter } = require 'events'

exports.AO = ASchema: class ASchema extends EventEmitter
  @comment: """
      My children represent the internal structure of instances of an AModel.
    """

  constructor: (@definingModel) ->
    unless @definingModel instanceof AModel
      
    @symbol = Symbol()
    @propDefs = {}
