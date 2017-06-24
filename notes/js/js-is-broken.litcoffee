Reading
https://zeekat.nl/articles/constructors-considered-mildly-confusing.html
and thinking maybe this model is terrible?

# My own expectations

## Inheritance

An "object" has a "parent" to which it delegates whatever it doesn't do
itself. This corresponds closely to an object's "[[prototype]]" in JavaScript.

## Classes

A class defines methods and properties which may be inherited either by
instances or sub-classes.

## Constructor

The distinction between constructor and initializer is becoming problematic. I
had never worried about the "construction" process in the ColdMUD days.
Objects were constructed by $sys.create and intialized by $root.initialize.

# "rambling" (vs what?)

## "Class" vs "Instance"

In some langauges Class.someMethod and (new Class).someMethod resolve to
different code. In MOO and ColdMUD they don't. In JavaScript it's a little
more complicated...

In JavaScript,

(new Class).someMethod === Class.protoype.someMethod.apply
(Object.create

    SomeClass = ->
    SomeClass.someMethod = -> "SomeClass.someMethod()"
    SomeClass.prototype.someMethod = -> "(new SomeClass).someMethod()"

    console.log SomeClass.someMethod()
    console.log (new SomeClass).someMethod()

## State namespace vs behavior namespace

It's neat that I can change the behavior of a thing by overwriting its
response to a message. It's annoying that (in JavaScript) state and message
handling namespaces are combined. I can't arbitrarily add state to an object
without risking a) overriding parent data b) overriding parent behavior. I
can't intentionally add a method to an object without potentially colliding
with a parent's expectations.

I think this might be part of the point of the concept of Interfaces?

ColdMUD dealt with this by making all data private. Access to local methods
was the exception, handled with .methodName(args...) or
.(methodNameExpr)(args...)

I had thought in my CORVID ramblings about including a context selector in
messages to make intentions more explicit, but I think what I really want is
for each object's reference to other objects to have that context information
already associated with it. In a sense I want all messages to be sent through
a proxy which remembers the context in which it was created.

The other problem I'm running into is the intermingling of levels. In the
ColdMUD world, $sys and $root had a difference concept of "name" from that of
$vr and such.

ANYWAY

What if objects' references to each other were contextual?

# Another way

What if I implemented my understanding of ColdMUD in
JavaScript/CoffeeScript...

## Multiple inheritance, disallow\_overrides...

In the old days there was some uncertainty about how best to handle two
parents defining the same method and the performance problems associated with
the DisOver flag.

What if we give up on the idea of complete control of an object's children and
instead say any time a specific method is required one invokes that method
directly and passes the instance in as a parameter?

For example:

  In the old Cold world .initialize was disOver. What if instead we called
  $root.initialize(newObject) as a class method?

In that case we reject the DisOver flag entirely, simplifying somethings.

## ColdObj

    ###
    MyMap = -> Object.create null

    class ColdObj
      constructor: (@parents = []) ->
        @data     = new Map
        @props    = MyMap() # changes to parent NOT reflected in children
        @methods  = MyMap() # changes to parent     reflected in children?
                            # Doesn't that violate the contract?
        @children = [] # direct descendents

        for p in @parents
          p.addChild this

      setMethod: (name, fn) ->

      resolveMethod: (name) ->
        if found = @methods[name]
          return found

        for p in @parents
          if found = p.resolveMethod name
            return found

      addChild: (child) -> child.addAncestor this

      addProp: (name, value) ->
        if name in Object.keys @props

      addAncestor: (ancestor) -> @data.set ancestor, Object.create null

      addDescendent: (o) ->
        @data[o] = new Map

      get: (parent, name) ->
        @data.get(parent)?[name]

      set: (parent, name, value) ->
        if not kidData = @data.get(parent)
          throw new Error "Invalid?"

        @data.get(child)[name] = value

    ###

## db

    ###
    db = []
    db.top = 0
    db.hidden = []

    db.create = (parent) ->
      o = db[db.top++] = Object.create parent
      o.parent = parent
    ###

## tokenServer

    ###
    tokenServer = ->
      serverNum = tokenServer.n++

      ->
        n = 0

        loop
          yield "#{tokenServer.n}.#{n++}"

    tokenServer.n = 0
    ###

## sys

    ###
    sys = db.create()
    sys.create = (parent = null) ->
      o = db.create parent
      if parent
        parent.initialize o

    ###
