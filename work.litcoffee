# Some utilities

Stuff like this is why Lisp programmers think they're so cool.

    # global.geese = [ { white: -> true }, { white: -> false } ]
    # all global.geese are 'white'
    # => false

    inverseFn = (fn) -> not fn()

    all = (l, check) ->
      check = inverseFn check
      -1 is l.findIndex check

    are = (methodName) ->
      (o) ->
        o[methodName]()


# Component

The Component is the basic unit of operations. It is composed of zero or more
inner Components we call parts. It is built on zero or more Components we call
dependencies.

A component has zero or more consumers it serves. Advanced components may not
consider themselves healthy unless their relationships with their consumers
are healthy.

The definition of a component includes the conditions under which it
transitions between various states. Requested indicates that the owner wants
that component built and healthy. Healthy indicates the component can operate
if online. The management of these states is handled elsewhere.

    class Component
      constructor: (info) ->
        { @name

          @parts        = []
          @dependencies = []

          @consumers    = []

          @requested    = -> false
          @healthCheck  = -> true
        } = info


## State

      state: ->
        if @requested()
          if @constructed()
            if @healthy()
              'healthy'
            else
              'unhealthy'
          else
            'building'
        else
          if @constructed()
            'decommissioning'
          else
            'specified'


I think this kind of thing is where CoffeeScript really shines:

      constructed: ->
        (all @parts        are 'constructed') and
        (all @dependencies are 'healthy')

      healthy: ->
        @constructed() and
        @healthCheck() and
        all @parts are 'healthy'
