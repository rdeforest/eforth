Sometimes people complain about not having any access control in ECMAScript.
Now that we have Symbol, maybe we can fix that?

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
protect them from themselves

    singletons = new Map

    class Singleton
      constructor: (args...) ->
        if singletons.has @constructor
          return singletons.get @constructor

        singletons.put @constructor, @

Yes. Yes there is. We don't even need a Symbol yet.

## Ok, but what about other kinds of private and protected members?

Suppose we want to dynamically add a restricted method to a class. We're
building an IDE and it's implemented in ECMAScript or something. We want the
user to be able to interact with instances of their objects under development,
including being able to add a private method to a class. That private method
should only be visible to instances of that class.

Presumably, public methods will use such a private method as a utility
function or something.

We can use scope to create the private method, but how do we maintain a
reference to it so that the public methods, defined later, have access to it?

    privateInstanceMembers = {}

    classSym = Symbol()

    our = makeOur Symbol()
    
    makeOur = (classSym) ->
      (member, value) ->
        if arguments.length > 1
          @[classSym][member] = value
          @
        else
          @[classSym][member]

    class PrivateRyan
      constructor: (args...) ->
