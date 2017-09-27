    if false

# Context

Looking at https://tc39.github.io/proposal-decorators/, I don't get the point.

It appears to propose to add syntactic sugar for function calls?

Before:

      classDecorator(
        class MyClass
          constructor    :                 (args...) ->

          instanceMethod : memberDecorator (args...) ->

          @classMethod   : memberDecorator (args...) ->
      )

After:

      @decorator
      class MyClass
        constructor:     (args...) ->

        @memberDecorator
        instanceMethod:  (args...) ->

        @memberDecorator
        @classMethod:    (args...) ->

# Pro

## Multi-decorator chaining obviates () and is verticle instead of horizontal

      @Data
      @Log.changes
      class Person
        #...

Without decorators, chain must be on same line or use parens AND indentation:

      Data Log class Person
        #...

or

      Data(
       Log(
        class Person
          #...
       ))


# scratch


## Required values

:/^start/+1,/^end/-2 ! ./evalcs
G

start

    R = require 'ramda'

    Required = (required..., fn) ->
      required = R.flatten required

      decorator = (args...) ->
        missing = new Set required

        for arg in args
          arg = Object.keys arg

          for name from required
            if name in arg
              missing.delete name

            return new fn args... unless missing.size

        missing = Array.from(missing).join ", "
        throw new Error "Required named arg(s) not found: #{missing} in args #{JSON.stringify args}"

      decorator.name = "@Required"
      decorator

    nameOf = (target) ->
      switch
        when name = target.name             then name
        when name = target.constructor.name then "(an instance of #{name})"
        else "(unnamed object)"

    LogChanges = (logger, klass) ->
      [logger, klass] = [console.log, logger] if not klass

      origProto = klass::

      newProto = new Proxy origProto,
        set: (target, prop, value, proxy) ->
          logger "%s.%s = %o", nameOf target, prop, value

      klass:: = newProto
      klass

    Person =
      LogChanges(
        Required( 'firstName', 'lastName',
          class Person
            constructor: ({ @firstName, @lastName }) ->

            toString: ->
              "new Person firstName: '#{@firstName}', lastName: '#{@lastName}'"
        )
      )

    alice = new Person firstName: 'Alice', lastName: 'Wonderland'

    module.exports = {LogChanges, Required, Person}

    console.log alice.toString()

stdout> done

end
