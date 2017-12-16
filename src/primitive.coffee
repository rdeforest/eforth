{
  listToObject, defaultCode
  functionRegexp, readOnly
  extractFunctionDefinition
  virtualFns
} = require './unrelated'

# In the forth world, 'CODE' means "here's some assembly to be added to the
# dictionary."

readOnly Primative, Symbol.species, Function

hasInit  = (klass) ->
  'function' is typeof klass::init

callInit = (klass, self, definition, rest) ->
  klass::init.call @, definition, rest...

class Verb
  # The constructor for instances of children of Verb.
  # It should not be overriden.

  constructor: (def, rest) ->
    if Verb is klass = @constructor
      throw new Error "Cannot instantiate abstract class 'Verb'."

    @impl = defaultCode

    name = null
    for name, definition of def when name isnt null
      throw 'definition must be a single-key object'

    if 'function' is typeof definition
      @impl = definition

    ( while klass isnt Verb
        currentKlass = klass
        klass = klass.constructor
        currentKlass
    ) .reverse()
      .filter  hasInit
      .forEach (klass) -> callInit klass, @, definition, rest

  # Define a descendant of Verb.
  #
  # @param def  name and implementation
  # @param rest args to definition
  # @returns    a function which constructs the class this was called on
  @define: (def, rest...) ->
    verb = new @ def, rest

    Object.defineProperties verb,
      name: value: name, configurable: true

    verb

  expand: (args...) -> @impl args...
  invoke: (args...) -> @impl args...

  @comment: """
    Verbs are DSL verbs and identifiers.

    I'm trying a couple of
    new things on this class:

     - The 'new Klass' is called by Klass.verb
     - The constructor args must start with a single-key object.
      - The key is used as the 'name' of the instance
       - meaning of which is defined elsewhere
      - The value is used as the first arg to 'init' calls
      - The constructor calls class::init with the afore mentioned args

    Verb.define creates children of Verb which
     - are functions
     - which create instances
    
    Example use:
      
      class PExample    extends Primitve
        init: (@args...) ->

    The default verb behavior is to return {self: this, args}.
    Verbs definitions may override the default by starting with a function:
    
        PExample myPExample: ((args...) -> body...), more, args

    If the primitive class takes additional args the function has to be
    wrapped in parens and followed by a comma:

        SpecializedVerb anotherExample: (
            (args...) -> body...
          ),
            [1..3].map doThreeThings
            anotherArg
            etc
  """

# Implements opcodes like LODSW and MOV
class Opcode            extends Verb
  init: (@implementation) ->

  expand: -> @

# A constant, register, reference, etc
class OpArg             extends Opcode

# An instruction with optional parameters
class Operation         extends Verb
  init: (@opcode, @args...) ->

  exec: (machine) ->
    @implementation @args.map (arg) -> arg.exec machine

# A labeled collection of instructions
class Code              extends Verb
  init: (definition, rest...) ->
    ops = [definition, rest...]

    @ops = []

    for op in ops
      if op not instanceof Operation
        throw new Error "Code may only contain Operations"

      @ops = @ops.concat op.compile()

  compile: -> @ops

# Code which is injected
# Maybe more like 'inline'?
class Macro             extends Code
  compile: -> @ops

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
  Verb, Macro, Opcode, Register
  ConstantNumber, DirectReference
}
