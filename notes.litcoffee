Going to assert some things. :)

    assert = require 'assert'

Special object members

  - \_\_proto\_\_: The object providing "inherited" values

    class Foo
      constructor: ->
        @instanceMember = {}

      classMember: {}

    foo = new Foo

    assert not Object.hasOwnProperty foo, 'classMember'
    assert foo.classMember is Foo.prototype.classMember

  - constructor: The function which spawned Foo
  - prototype: The default \_\_proto\_\_ of objects constructed by this

    assert foo.constructor is Foo
    assert foo.__proto__   is Foo.prototype

One reason to use \_.extend for 'inheritance' is for speed. If none of your
classes use something like 'super' or 'pass' then there's no reason to
traverse the ancestors looking for methods.

If you want to do both (null \_\_proto\_\_ and still inherit) you can make your
'super' function look up .constructor.prototype.method and .call it with this.
CoffeeScript stores .constructor.prototype in class.\_\_super\_\_ so maybe
there's something to that.

    class Bar extends Foo

    assert Bar.__super__ is Foo.prototype

So what is the "parent" of an object in a world where the dumb class/instance
dichotomy has been foisted on a prototypal system? Is Foo the parent of Bar?
Is bar a descendent of Foo? _I don't know._
