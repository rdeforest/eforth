hasInit  = (klass) ->
  'function' is typeof klass::init

callInit = (klass, self, definition, rest) ->
  klass::init.call @, definition, rest...

listToObject = (entries) -> Object.assign {}, entries...

defaultCode = ((args...) -> {this: this, args}).toString()

functionRegexp = ///
    ^ function \s*
    \( \s* ([^)])* \) \s*  # args
    { \s* (.*) }           # body
  ///

extractFunctionDefinition = (fn) ->
  code =
    if 'function' is typeof fn
      code = fn.toString()
    else
      defaultCode

  matched = code.match functionRegexp

  unless matched
    throw new Error "code.toString() didn't match the function pattern. Value was:\n#{code}"

  [theWholeString, argStr, body] = matched

  argNames =
    argStr
      .split /\s*/
      .map (argName) -> argName.trim()

readOnly = (obj, nameOrSymbol, value) ->
  Object.defineProperty obj, nameOrSymbol, get: -> value

readOnly Primative, Symbol.species, Function

class Macro    extends Primitive
  init: (definition, rest...) ->
    @ops = [definition, rest...]

class Opcode   extends Primitive
  init: (definition, rest...) ->
    if definition
      @args = [definition, rest...]

class Register extends Primitive

class RegisterReference extends Register
  constructor: (def, rest...) ->
    def[Object.keys(def)[0]] =
      (offset = 0) -> {this: this, offset}

class ConstantNumber extends Primitive
  init: (@value) ->
    unless 'number' is typeof @value
      throw new Error 'wat'

# A number referring to a specific address
class DirectReference extends ConstantNumber

Object.assign module.exports, {
  Macro, Opcode, Register
  ConstantNumber, DirectReference
  extractFunctionDefinition # for testing purposes
}
