    cs = require 'coffee-script'
    vm = require 'vm'

Some utlity

    overrideParam = (orig, overridden, overrideFn) ->
      prxy = new Proxy orig,
        get: (pname) ->
          if pname is overriden
            overrideFn()
          else
            orig[pname]

    str2num = (s) ->
      switch typeof s
        when 'number' then s
        when 'string' then parseInt s
        else throw new Error "'#{s}' is neither a string nor a number."

    val2fn = (v) ->
      if 'function' isnt typeof v
        v = -> v

      v

    overrideLength = (origFn, length) ->
      overrideParam origFn, 'length', val2fn str2num length

Turn CoffeeScript 'code' into a function whose version of 'global' is not the
same as the 'real' global, and expose that inner global for manipulation.

    Code =
      cs.nodes '->'
        .expressions[0]
        .constructor

    exposeFunction = (code) ->
      nodes = cs.nodes code

      if nodes.expressions[0] not instanceof Code
        throw new Error 'Code does not represent a function'

      compiled = cs.compile """
        (#{code}) args...
      """

      script = new vm.Script compiled,
        produceCachedData: true

      ctx = vm.createContext glb = {}

      wrapper = (args...) ->
        ctx[argsSym] = args
        script.runInContext ctx,
          breakOnSigint: true

