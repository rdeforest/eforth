# goofing around with a modular string formatter idea

# FMT = Fsck My Text :)

###

Without withMetaClass:

    FMTLexer.constructor         is Function
    FMTLexer.__proto__           is Function::
    FMTLexer.prototype.__proto__ is Object::

    (new FMTLexer).constructor   is FMTLexer
    (new FMTLexer).__proto__     is FMTLexer::

With:

    FMTLexer.constructor         is FMTClass
    FMTLexer.__proto__           is FMTClass::
    FMTLexer.prototype.__proto__ is Function::

    (new FMTLexer).constructor   is still FMTLexer
    (new FMTLexer).__proto__     is still FMTLexer::

###

withMetaClass = (metaClass, definedClass) ->

class MetaClass
  @concrete: -> new @constructor arguments...

class FMTClass extends MetaClass
  selfie: (fn) ->
    (args...) =>
      fn args...
      @

  abstractMethod: (fn) ->
    ctorName = @name

    (params = fn
      .toString()
      .match /function ^[^(]*\(([^)]*)\)/
    )[1]

    msg = (name, params, ctorName) ->
      util.format "Abstract method #{ctorName}::%s(#{params}) not overriden on %s::"

    fnName = null

    alert = ->
      throw new Error msg name, params, @contructor.name

    setImmediate =>
      fnName =
        Object.getOwnPropertyNames @::
          .find (name) -> @::[name] is alert

    return alert

# turns strings into lists of tokens
class FMTLexer extends FMTClass.concrete()
  constructor: ->
    @rules = []
    @tokenNames = {}

  #addRule: @selfie (pattern, tokenName) ->
  #  if @tokenNames[tokenName]
  #    throw new Error "duplicate token name #{tokenName}"
  #  @rules.push [pattern, tokenName]

  #tokenize: @abstractMethod (text, opts = {}) ->

# turns lists of tokens into ASTs
class FMTGrammar   extends FMTClass
  constructor: ->
    @nodes = {}

  #addNode: selfie (args) ->
  #  if 'string' is typeof args[0]
  #    #[name, pattern, action, opts] = args
  #    @nodes[name] = args[1..]
  #  else
  #    for name, rest of args
  #      #[pattern, action, opts] = rest
  #      @nodes[name] = rest
  #      break

# turns ASTs into Formatters
class FMTGenerator extends FMTClass

# combines the above
class FMTSyntax    extends FMTClass
  constructor: (@tokenizer, @grammar, @generator) ->

# turns a string and some data into a new string
class Formatter    extends FMTClass
  constructor: (@syntax, @opts = {}) ->

# E stands for Example
class ELexer extends FMTLexer
  tokenize: (text, opts) ->

class EGrammar extends FMTGrammar

class EGenerator extends FMTGenerator

eSyntax = new FMTGrammar ELexer, EGrammar, EGenerator

Object.assign global, module.exports = {
  MetaClass, FMTClass,
  FMTLexer, FMTGrammar, FMTGenerator, FMTSyntax, Formatter,
  ELexer, EGrammar, EGenerator, eSyntax
}
