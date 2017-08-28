Object.assign global, require 'ramda'
cs = require 'coffee-script'

# Time to practice some point-free programming

# First experiment: designing a MUD top-down
#
# Assuming our entry point is a line of input and our return value is the
# resulting text...

nonWordString = /\s+/

handlers = {}

commands = []

sortIntentsByConfidence =
  sortWith [
      R.descend length prop 'resolved'
      R.ascend  length prop 'unresolved'
    ]

cmdToItents =
  commands.filter globMatcher prop 'inputPattern'

quoting =
  both (complement empty),
       (equals '\\', last last)

appendToLast = R.set tailLens

combineTokens = (combined) ->
  R.if (quoting combined),
       (R.set ),
       ()

globParser = (glob) ->
  pipe [
    split ''
    reduce [], combineTokens
  ]

globMatcher = (glob) ->

makeCommand = (inputPattern, handler) ->
  commands.push {inputPattern, handler}



# Function as object: fn(message, args)

class OOExample
  constructor: (@state) ->

  toString: -> "new OOExample #{JSON.stringify @state}"

FNExampleFactory = (state) ->
  methods =
    toString: -> "new OOExample #{JSON.stringify state}"

  methodNotFound = (method, args...) ->
    console.log "Method '#{method}' not defined"

  (message, args...) ->
    if fn = methods[message]
      fn args...
    else
      methodNotFOund message, args...

###

pro
- true information hiding due to lacking a way to access the inner scope

con
- can't add methods dynamically due to lacking a way to access the inner scope
- needs syntactic sugar

other
- no inheritance

###

dispatcher = """
  ((message, args...) ->
    switch message
      when delMethod
        methods[args[0]] = undefined
        return
        
      when addMethod
        [message, compiled] = args
        methods[message] = cs.eval "({self, definer}, args...) -> compiled.apply self, args"
        return

      when resolve
        [message, args...] = args
        justResolve = true

    found =
      definer: self
      self: fn
      method: methods[message]

    if not found.method
      for parent in parents when (found = parent arguments)
        found.self = fn

        if justResolve
          return found

        break

    found.method ?= methodNotFound

    found.method.apply found, args...
  )
"""

FNFactoryBuilder = (name, info = {}) ->
  { methods = {}
    methodNotFound = ->
    parents = []
  } = info

  resolve = Symbol()

  self = {}

  fn = cs.eval dispatcher
  fn.name = name
  fn

FNExample = FNFactoryBuilder "FNExample",
  methods:
    toString: -> "new OOExample #{JSON.stringify @}"

  (message, args...) ->
    console.log "Method '#{method}' not defined"

fnInstance = FNExample()

fnInstance 'toString'

# That's better :)

