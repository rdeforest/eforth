

    mixin = require './non-cold/mixin'

    methodRepository =
      definers: (name) -> @methodNames[name]

      add: (name, definer) ->
        (@methodNames[name] or= new Set).add definer

      remove: (name, definer) ->
        @methodNames[name]?.delete definer

      methodNames: {}

    MessageReceiver = mixin.define
      repo: methodRepository

      methods: -> @stateBucket 'methods'

      init: (args) ->
        @methods.set {}

      methodCache: {}

      lookupMethod: (methodName) ->
        methodCache[methodName] or @methods.get()[methodName]

      addMethod: (name, method) ->
        if @cantInheritMethod name
          throw new Error "Method name conflict"

        @methods.set @methods.get()[name] = method
        @repo.add name, this

        for kid in @children
          kid.updateMethodCache this, name, method

      updateMethodCache: (definer, name, method) ->
        
        
      cantInheritMethod: (name) ->
        if @lookupMethod name
          return true

        for definer in @repo.definers name when definer.hasAncestor this
          return true

        if @haveMethod name
          return true

        kids = @children()

        for kid in kids when kid.cantInheritMethod name
          return true

    MessageReceiver.repo = methodRepository

    module.exports = MessageReceiver

# old notes

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

