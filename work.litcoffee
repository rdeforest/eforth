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

A component knows where in its lifecycle it currently is.

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


Components default to being requested by virtue of having been instantiated.

      requested: -> yes

# Component extensions

## Environment

Environment is Amazon-speak for service, sortof. It's a collection of packages
which knows how to install, upgrade and uninstall itself and knows how to
combine its context with specifications to expose a relevant configuration.

Its @parts are its stages: alpha, beta, gamma, prod.

    class Environment extends Component
      stage: (name) ->
        @parts.find (p) -> p.name is name

      stages: ->
        ret = {}

        for stage in @parts
          ret[stage.name] = stage

        ret

      setStage: (stage) ->
        if -1 is idx = stageIdx stage.name
          return @parts.push stage

        old = @parts[idx]

        old.replacingWith? stage
        stage.replacing? old

        @parts[idx] = stage

        old.replacedWith? stage
        stage.replaced? old


## Pipeline

A Pipeline is a workflow. They were originally for building and deploying
environments but I have ideas about how to use environments to manage larger
systems such as Sites and Regions.

Our model is a facade (or is it an adapter? proxy? :) in front of the existing
Pipelines API


    class Pipeline extends Component
      # not yet implemented

    class PipelineStep extends Component
      # not yet implemented

## HostClass

A HostClass applies permissions to hosts and provides Apollo with a name for
the collection of hosts it contains.


## Package


## VFI



