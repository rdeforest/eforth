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

# Meta-object protocol

- Implement Cold's inheritance and data models
- Communication between objects exclusively via "messages"

## DB

    class ColdDB
      constructor: ->
        @objs = []
        @names = {}
        @nextId = 0
        @_initMinimal()

      create: ->
        o = new ColdObject @nextId++
        @objs.push o
        return o

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

## Database

    class ColdDB
      constructor: ->
        @ready = false
        @dbTop = 0
        @objects = {}
        @tasks = {}

        @_initMinimal()

      _initMinimal: ->
        sys = @create()
        root = @create()

        @addParent sys, root

      resumeFromDir: (dir) ->

      create: ->
        id = @dbTop++
        @objects[id] = new ColdObject id

      addParent: (subject, parent) ->
