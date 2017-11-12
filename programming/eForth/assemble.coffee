{ Macro, Opcode, Register
  ConstantValue, DirectReference
} = require './primitives'

{ listToObject } = require './shared'

assembleWord = (ops) ->
  assembled = []

  ops.forEach (op, i, ops) ->
    assembled = op.appendTo assembled

    switch
      when op instanceof Macro assembled = assembled.concat op

module.exports.assemble = (namesAndCode) ->
  return listToObject (
    for name, code of namesAndCode
      "#{name}": assembleWord code
  )
