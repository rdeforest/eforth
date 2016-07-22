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

