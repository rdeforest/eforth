class Primitive extends Function
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
      
      class PExample extends Primitve
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


