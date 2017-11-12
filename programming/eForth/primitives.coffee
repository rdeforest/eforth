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

class Primitive extends Function
  @comment: """
    My derivatives are DSL verbs and identifiers.


    
    The default verb behavior is to return {this, args}.
    Verbs definitions may override the default by starting with a function:
    
        Primitive example: (args...) -> body...

    If the primitive class takes additional args the function has to be
    wrapped in parens and followed by a comma:

        SpecializedPrimitive anotherExample: (
            (args...) -> body...
          ),
            [1..3].map doThreeThings
            anotherArg
            etc
  """

  constructor: (def, rest...) ->
    unless 'object' is typeof def and Object.keys(def).length is 1
      throw 'definition must be a single-key object'

    code = defaultCode

    ( for name, definition of def
        if 'function' is typeof definition
          code = definition.toString()

        {argNames, body} = extractFunctionDefinition code

        super argNames..., body

        klass = @constructor

        while klass isnt Primitive
          currentKlass = klass
          klass = klass.constructor
          currentKlass
    ) .reverse()
      .filter  hasInit
      .forEach (klass) -> callInit klass, @, definition, rest

    @constructor[@name] = @

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
