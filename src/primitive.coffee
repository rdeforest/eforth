{
  listToObject, defaultCode
  functionRegexp, readOnly
  extractFunctionDefinition
} = require './unrelated'

readOnly Primative, Symbol.species, Function

hasInit  = (klass) ->
  'function' is typeof klass::init

callInit = (klass, self, definition, rest) ->
  klass::init.call @, definition, rest...

class Primitive         extends Function
  @comment: """
    Derivatives of Primitive are DSL verbs and identifiers.

    I'm trying a couple of
    new things on this class:

     - The constructor doesn't need to be called with 'new'.
     - The constructor args must start with a single-key object.
      - The key is used as the 'name' of the instance
       - meaning of which is defined elsewhere
      - The value is used as the first arg to 'init' calls
      - The constructor calls class::init with the afore mentioned args
    
    Example use:
      
      class PExample    extends Primitve
        init: (@args...) ->

    The default verb behavior is to return {self: this, args}.
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

# Implements opcodes like LODSW and MOV
class Opcode            extends Primitive
  init: (@implementation) ->

  exec: (machine, args...) ->
    @implementation (
      args.map (arg) ->
        arg.exec machine
    )

# A constant, register, reference, etc
class OpArg             extends Opcode

# An instruction with optional parameters
class Operation         extends Primitive
  init: (@opcode, @args...) ->

# A labeled collection of instructions
class Code              extends Primitive
  init: (definition, rest...) ->
    ops = [definition, rest...]

    @ops = []

    for op in ops
      if op not instanceof Operation
        throw new Error "Code may only contain Operations"

      @ops = @ops.concat op.expanded()

  exec: (machine) ->

  expanded: -> @

# Code which is injected
# Maybe more like 'inline'?
class Macro             extends Code
  expanded: -> @ops

# Code associated with the dictionary?
class Word              extends Code

# Word implemented directly in Java/Coffee script
class NativeWord        extends Word

# An machine register client
class Register          extends OpArg

# An indirect reference (such as IP + 1 or IP + AX)
class RegisterReference extends Register
  constructor: (def, rest...) ->
    def[Object.keys(def)[0]] =
      (offset = 0) -> {this: this, offset}


class ConstantNumber    extends OpArg
  init: (@value) ->
    unless 'number' is typeof @value
      throw new Error 'wat'

# A number referring to a specific address
class DirectReference   extends ConstantNumber

Object.assign exports, {
  Primitive, Macro, Opcode, Register
  ConstantNumber, DirectReference
}
