# Prelude?

    _ = require 'underscore'

# CoffeeScript with ColdMUD assumptions?

## ColdMUD assumptions

- All changes to objects persisted at end or suspension of task.
 - Task execution starts with network input or resumption of suspended tasks.

- Handy sockets
 - So here's our hook
  - the engine handles the network and tasks
  - bounding with persistence is just book-keeping

# Different from ColdMUD

- Object messages are asynchronous
 - Data changed before message processing has resolved is not persisted or
   exposed to other "threads"
 - A "thread" is associated with an external event
  - network, timeout, process signal, etc
 - At the start of a message event, the event gets a unique ID and a pointer
   to a version of the knowledge tree at the start of the thread
 - Changes within the event (including outbound I/O) are saved up until it
   reaches some sort of conclusion:
   - timeout
   - out of "ticks"
   - originating Promise resolved or rejected

    class ExternalMessageEvent
      constructor: ({@db, @message, @timeout = 1000}) ->
        @id = Symbol()
        @worldView = @db.snapshot()
        @changes = []
        @rolledBack = @committed = false

      start: ->
        @timeoutTask = setTimeout @timedOut.bind(this), @timeout

        @message.send via: this
          .then      => @commit()
          .catch (e) => @rollback e

      commit: ->
        if @timeoutTask
          clearTimeout @timeoutTask
          @timeoutTask = undefined

        if @committed
          return

        if @rolledback
          throw new Error "Can't commit, already rolled back"

        try
          newWorld = @db.logChanges @changes
          @committed = true
        catch e
          @rollback e
          return

        try
          @message.reply result: newWorld

      rollback: (e) ->
        if @rolledback
          return

        if @committed
          throw new Error "Can't roll back, already committed"

        @rolledBack = true
        @message.reply error: e

      timedOut: ->
        @rollback new Error "Event ran out of processing time"


# Meta-object protocol

- Implement Cold's inheritance and data models
- Communication between objects exclusively via "messages"

## DB

The DB handles the object lifecycle, including persistence and versioning.

    class ColdDB
      constructor: ->
        @log = []
        @current = {}
        @_initMinimal()

      _initMinimal: ->
        sys = @create()
        root = @create()

        @addParent sys, root

      snapshot: ->
        snap = Object.assign {}, @current

      create: ->
        o = new ColdObject
        @logChanges [ { newObject: o, id: o.id } ]
        return o

      lookup: (id) ->
        if not o = @objs[id]
          throw new Error "~objnf"

        return o

      destroy: (id) ->
        o = @lookup id
        @dieing[id] = o
        @objs[id] = null



## Messages

- sender, caller, definer, this, methodName, args

## Task

- originating socket (?)
- stack
- changes

## Socket

## ColdCoffee

    ColdCoffee
      compiler: (code) ->
        # convert '#123' object references into ColdObjRef thingie
        # convert '$foo' into lookup by name and ref creation

## Method

    class ColdMethod
      constructor: (info) ->
        { @definer, @name
          @argNames = []
          @code = ""
          @compiler = ColdCoffee.compiler
        } = info

        @fn = @compiler @code

## ColdObjRef

In order to simplify messaging, ColdObjects view each other through references
unique to each relationship. The reference knows who the sener and caller
are and constructs the message accordingly. Even self-messaging goes through a
reference so that the definer knows who the sender is.

    class ColdObjRef
      constructor: ({@referrer, @referred}) ->
      
      createMessage: (methodName, args, sender = @referrer) ->
        new ColdMessage
          sender: sender
          caller: @referrer
          methodName: methodName
          args: args
          self: @referred
          definer: @referred.matchMethod @referrer, methodName, args

## ColdObject

ColdObject handles the MOP:
- add/remove parent
- add/remove objectVar
- add/remove method
- receive message

    class ColdObject
      constructor: (@id) ->
        @ownData = {}
        @ownMethods = {}

        @parents = []
        @knownChildren = []
        @overriddenData = {}
        @inheritedMethods = {}

      addChild: (child) ->

      parentMethodCollisions: (parent) ->
        _.intersection @allMethods(), parent.allMethods()

      addParent: (parent) ->
        if @parentMethodCollisions(parent).length
          throw new Error '..'

        for method in parent.allMethods()
          @inheritedMethods[method.name] = method

      lookupMethod: (methodName) -> inheritedMethods[methodName]

      addMethod: (name, args, opts, code) ->
        @ownMethods[name] = method =
          new ColdMethod {name, definer: this, argNames: args, opts, code}

        for child in @knownChildren
          

What should happen when someone tries to add a method to a parent which is
already defined on a descendant or a descendant's ancestor? This could get
gnarly.

### Check first

Check all descendants for a conflict, throw an error instead of adding the
method.

- Gives children power of parents which they probably shouldn't have.
- Makes adding methods to heavily shared objects expensive.

### No new methods on objects with children

- Imposes admin cost of having to migrate children to new parent with new
  method.
- Forces change management?
- How to ensure children of different versions of a parent behave well?
 - engineering?

