###

This library should put Robert de Forest in his comfort zone. That is...

    require 'rdf'

means

    "it's going to be fine"

###

e = {}

###

"making it all right"

A no holds barred library for bending NodeJS to my will.

Principles:

- One object, one job
- Favor composition over inhertiance
- Favor functional over object-oriented.
 - Evaluate lazily
 - Contain side-effects

- Introspection is documentation
 - d object
 - d object, '.'

- Separate inheritance/composition from namespace
 - $.meta.whatever isn't necessarily a child of $meta
 - 'global' namespace is how objects interact with their context
 - All objects constructed with a namespace

Objects:

- Root
 - What is common amongst all objects ever
 - child of null

###

define Root: {}

###

- HandlerMap
 - has
  - methods : Namespace <handlerName : String, handler : Function>

###

class MessageHandler
  constructor: (@name, @fn) ->

  send: (message) ->
    ColdVM.startFrame message, @

class HandlerMap
  constructor: ->
    @handlers = {}

  addHandler    : (name, fn) -> @handlers[name] = fn
  removeHandler : (name)     -> @handlers[name] = undefined
  getHandler    : (name)     -> @handlers[name]
  listHandlers  :            -> Object.keys @handlers

###

- MethodSignature
 - has
  - messageName
 - does
  - matchCall messageName, args...
  - only checkes messageName
  - children provide advanced matching features

###

class MethodSignature
  constructor: (@messageName) ->

  matchCall: (messageName) -> messageName is @messageName

###

- MessageMatcher
 - has
  - signatures [methodSignature...]
 - does
  - match messageName, args...
  - addSignature methodSignature

###

class Message
  constructor: ->
    @name     =
    @args     =
    @caller   =
    @sender   =
    @definer  =
    @receiver =
      null

  name:     (@name)     -> return @
  args:     (@args...)  -> return @
  caller:   (@caller)   -> return @
  sender:   (@sender)   -> return @
  definer:  (@definer)  -> return @
  receiver: (@receiver) -> return @

  send: ->
    missing =
      'name args caller sender definer receiver'
        .split ' '
        .filter (prop) -> message.prop is null

    if missing.length
      throw new e.incompleteMessage missing

e.incompleteMessage = (missing) ->
  "Incomplete message. Missing #{English.pluralNoun 'field', missing}: #{English.list missing}"

class MessageMatcher
  constructor: ->
    @signatures = {}

  addSignature: (handlerName, sig) ->
    @signatures[handlerName] = sig

  match: (messageName, args...) ->
    for handlerName, sig of @signatures when sig.match messageName, args...
      return handlerName

  listSignatures: -> Object.keys @signatures

###

- MessageDispatcher
 - has
  - HandlerMap     handlers
  - MessageMatcher patterns

  - does
   - receive messageName, args...

  - listHandlers()                        : Map<handlerId, handler>

  - addMessagePattern(pattern, handlerId)
  - lookupMethod(messageName)             : found    MatchedMethod
  - define

###

nameOf = (o) ->
  o.name ? "(instance of #{o.constructor.name})"

e.methodnf = ({instance, messageName, args}) ->
   "Couldn't find a method matching #{nameOf instance}.#{mssageName}" 

class MessageDispatcher
  constructor: ->
    @handlers      = new HandlerMap
    @methodMatcher = new MethodMatcher

  receive: (instance, messageName, args...) ->
    if handlerName = @methodMatcher.match messageName, args...
      handler = @handlers.getHandler messageName

      handler.apply instance, args
    else
      throw new Error e.methodnf {instance, messageName, args}

###

- MethodCall
 - has
  - sender   : Root
  - receiver : Root
  - caller   : MessageDispatcher
  - definer  : MessageDispatcher
  - messageName
  - args

 - does send(messageName, args...)

###

class MethodCall

###

- MetaClass
 - Scaffolding for the MOP
 - Parent to Class
 - child of Root
 - responsible for the "do this to that" mode of interaction

Discussion:

If .create is defined on Root, every object gains a .create method. No object
can ever have a 'create' member which means anything different from what is
defined on Root.

If .create is defined as "Object.create(parent, options) => child",

- Object becomes gate-keeper to create operations
- The global namespace is kept clean

###


###

- Class
 - Scaffolding for OP
 - child of Root

###


###

- Sys
 - Gateway to all things privilidged
 - child of Meta

###


###

- Function
 - child of Meta
 - does
  - apply/call
  - sig() : FunctionSignature

###


###

- Namespace
 - child of Meta
 - does
  - lookup(Path path) : Optional
 - has ...

- Optional
 - child of Meta
 - does
  - isPresent() : Boolean
  - apply(Function) : any

###


###

- Member
 - child of Root
 - Has namespace
 - Has name

###


###

- Method
 - child of Member

Other stuff

Verb usage

 - 'create'  instantiates  an entity
 - 'destroy' deconstructs  an entity

 - 'delete'  is never used

 - 'add'     associates    an entity with a set
 - 'remove'  disassociates an entity from a set

 - 'set'     associates    an entity with a key
 - 'get'     fetches       an entity its    key
 - 'unset'   disassociates an entity from a key

 - 'match'   groups the members of a collection by match quality
 - 'lookup'  is 

 - 'fetch'   has latency and resource cost

###


###

Questions:

- How do we reconcile functional and ColdMUD programming styles?
 - No side effects until task completes?

###

