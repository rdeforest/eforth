Sometimes people complain about not having any access control in ECMAScript.
Now that we have Symbol, maybe we can fix that? (Previously we had namespace
collision problems with strings).

# Use cases

## Controlling construction of the class

Sometimes one wants to guarantee there is only one instance of a singleton.
Since a constructor can return an already constructed object, this is trivial:

    class Singleton
      @singletons = new Map

      constructor: (args...) ->
        if @singletons.has @constructor
          return @singletons.get @constructor

        @singletons.put @constructor, @

However, a poorly trained or insane user of this class might be tempted to
inspect or modify the Singleton.singeltons class variable. Is there a way to
protect them from themselves...

    singletons = new Map

    class Singleton
      constructor: (args...) ->
        if singletons.has @constructor
          return singletons.get @constructor

        singletons.put @constructor, @

Yes. Yes there is. We don't even need a Symbol yet.

## Ok, but what about other kinds of private and protected members?

We want to add a method to instances of a class which has limited visibility.
We can't keep a caller from proxying calls, but that's true anyway.

### Private = Only self and children can invoke it

    parentSymbols = new Map

    ParentSymbol = Symbol()

    class Parent
      constructor: (opts = {}) ->
        @setParentSymbol Parent, ParentSymbol

    Parent::[ParentSymbol].privateMethod = (args...) ->

    callPrivate = (self, method, args...) ->
      self[parentSymbols.get self.constructor.__super__][method]
        .apply self, args

    ChildSymbol = Symbol()

    class Child extends Parent
      setParentSymbol: (parent, sym) ->
        if @ not instanceof parent
          throw new Error 'wat'

        parentSymbols.set parent, sym

      constructor: (opts = {}) ->
        super
        @set

      someMethod: ->
        callPrivate @, 'privateMethod', args: 'some args'

This is clearly workable, but a huge pain. Time to go back to the MOP...
