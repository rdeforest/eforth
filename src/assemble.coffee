{ Macro, Opcode, Register
  ConstantValue, DirectReference
} = require './primitives'

{ listToObject } = require './unrelated'

assembleWord = (ops) ->
  assembled = []

  ops.forEach (op, i, ops) ->
    assembled = assembled.concat op.expand()

module.exports.assemble = (namesAndCode) ->
  return listToObject (
    for name, code of namesAndCode
      "#{name}": assembleWord code
  )
