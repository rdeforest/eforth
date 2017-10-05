- Private
 - Method
  - sender() === this()
  - caller() === definer()
 - Prop
  - Per-instance-only visibility

- Protected
 - Method
  - caller() instanceof definer()
 - Prop: no thank you

- Public
 - default

- Other
 - caller() === definer()
  - Not 'private' because instances can reference each other
  - Not 'protected' because only methods defined on this class can access other instances this way

- Static
 - Method
  - No access to self/this; a "utility" method (more like just a function)
  - If constructors inherited from each other 

    shared   = Symbol()
    instance = Symbol()

    privateStaticExample = ->

    privMethod = (fn) ->
      (self, args...) ->
        fn.apply self, args

    privateMethod = priv (args...) ->
      # some code

    privProps = {}

    privProp = (name) ->
      (nameAndValue) ->
        for k, v of nameAndValue
          privProps.push nameAndValue
          curValue = self[instance][member]

          return (self, newValue) ->
            self[instance][member] = newValue if arguments.length
            curValue

    propExample = privProp example: 'example value'

    getProtected = (self, member) ->
      if 'function' is typeof found = self[shared][member]
        found.bind self

      found

    class ClassName
      @publicStatic: ->
      public: ->

      constructor: (info = {}) ->

      usesProtected: (args...) ->
        foo = getProtected @, 'foo'

        foo isProtected: bar

      usesPrivate: (args...) ->
        bar = privateExample.bind @

        bar isPrivate: true

And about that prototypal inheritance...


class Foo extends Bar

foo = new Foo

Object.getPrototypeOf foo
 is 'Foo {}', meaning Foo::

Object.getPrototypeOf Foo
 is '[Function]', meaning Function::

If we were to

class MetaFoo

MetaFoo:: = Foo
metaFoo = new MetaFoo

then

Object.getPrototypeOf metaFoo
 is Foo

If we

class MetaBar extends MetaFoo

metaBar = new MetaBar

class Root

sys = new Root

Constructor | Proto      | An instance
------------+------------+---------
Klass       | Klass::    | klass
Function    | Function:: | ->
Object      | Object::   | {}
Root        | Root::     | sys

------

An object whose instances respond to 'new'

    class MetaClass
      constructor: (name, constructor, proto) ->
        klass = class
          constructor: (args...) ->
            intance = Object.create klass::

        klass:: = proto

        return klass

Usage

    FooClass = new MetaClass 'FooClass', (info = {}) -> # ...

    foo = new FooClass some: 'info'

Why? Because MetaClass::whatever is accessible as ChildClass.whatever

