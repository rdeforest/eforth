Object.assign global, require 'ramda'
cs = require 'coffee-script'
R = require 'ramda'

# Time to practice some point-free programming

# First experiment: designing a MUD top-down
#
# Assuming our entry point is a line of input and our return value is the
# resulting text...

nonWordString = /\s+/

isFunctionDef = R.match /// ^ \s* ( [(] [^)]* [)] \s*)?  -> ///

compileFunction = R.curry cs.eval

addHandler = R.assoc k, R.prop(k, __), handlers

addHandlers = R.mergeAll R.map addHandler, R.keys

handlers = {}

handlers = addHandlers
  addHandler: R.ifElse
    
  ([cmd, name, colon, def]) ->
    compiled = cs.eval def

    handlers[name] = compiled
    console.log "Added/edited handler '#{name}'"

  addCommand: ([cmd, inputPattern, colon, handlerName]) ->
    if not handler = handlers[handlerName]
      return console.log "No handler named '#{handlerName}' exists"

    if -1 < (idx = commands.findIndex (cmd) -> cmd.inputPattern is inputPattern)
      commands[idx].handler = handler
      return console.log "updated handler"
    else
      commands.push {inputPattern, handler}
      return console.log "Added command pattern for handler '#{handlerName}'"

commands = [
  { inputPattern: "addHandler *: *", handler: addHandler }
  { inputPattern: "addCommand *: *", handler: addCommand }
]

sortIntentsByConfidence =
  sortWith [
      R.descend length prop 'resolved'
      R. ascend length prop 'unresolved'
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

        return found if justResolve

        break

    found.method ?= methodNotFound

    found.method.apply found, args...
  )
"""

FNFactoryBuilder = (name, info = {}) ->
  { methods = {}
    methodNotFound = ->
    parents = []
    self = {}
  } = info

  resolve = Symbol()

  fn = cs.eval dispatcher
  fn.name = name
  fn



# That's better :)
# Though I wonder if there's a way to do that point-free...

methodSetToFactory = (methods) ->
  for k, v of methods when 'function' isnt typeof v
    throw new Error 'non-function method not supported'

  methods = Object.assign {}, methods

  dispatcher = (method, args...) ->
    if method

