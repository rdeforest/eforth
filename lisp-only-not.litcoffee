# wat

## the good

- I like the elegance of Lisp's syntax.
- I like that Lisp operates on itself. It's the ultimate in dogfooding.

## the bad

- Lisp syntax is oddly verbose for how light it is
 - adding meaning to more tokens could help?
 - significant whitespace (CoffeeScript) could help?

# so...

## How

- Tiny 'vm' build on Node.
- The rest implemented in itself.

If it turns out to be useful we'll think about performance. Maybe switch to
llvm or crystal-lang or something.

### The 'vm'

    class VM extends EventEmitter
      @ops: {}

      constructor: ->
        @ops        = VM.defaultOps
        @defs       = VM.defaultDefs
        @frameStack = []

      start: ->
        @_sanityCheck 'start' # throws on error

        @runningTask = setImmediate =>
          @emit 'starting'
          @_jump @entryPoint()
          @_runningTask = null
          @emit 'finished'

      abort: ->
        if @_runningTask
          clearImmediate @_runningTask
          @_runningTask = null
          @emit 'aborted'

      freeze: (writeableStream) ->

      thaw:   ( readableStream) ->

    makeArgSpec = (required = [], optional = [], slurpy) ->
      optNames = []

      if 'string' is typeof slurpy
        optNames.push slurpy
      else
        slurpy = false

      for opt in optional
        for name, value of opt
          if name in required.concat optNames
            throw new Error "name conflict for '#{name}'"

          optNames.push name

      for name, i in required
        if 'string' isnt t = typeof name
          throw new Error "invalid arg spec: #{i}th arg is a/an #{t} instead of a string"

        if name in required[i + 1..]
          throw new Error "name conflict for '#{name}'"

      spec = null

      _slurp = (args) ->
        args = spec args[..]
        args.named[slurpy] = args.positional
        args.positional = []
        args

      _opt = (args) ->
        for opt, i in optional
          for name, defValue of opt
            next if name in Object.keys args.named

            args.named[opt] =
              if args.positional.length
                args.named[opt] = args.positional.shift()
              else
                defValue
        args

      _req = (positional, named = {}) ->
        if rawArgs.length < required.length
          return error: "insufficient args"

        args = { named, positional }

        for req, i in required
          if req not in Object.keys args.named
            args.named[req] = args.positional.shift()

        return args

      if slurpy
        spec = _slurp

      if optional.length
        spec =
          if spec
            (args) -> spec _opt args
          else
            _opt

      if required.length
        spec =
          if spec
            (args) -> spec _req args
          else
            _opt

      spec or= (positional) -> { named: {}, positional }

    class OpCode
      @def: (@name, @argSpec, @impl) ->

      constructor: (@name, @argSpec, @impl) ->
        VM.ops[@name] = @

      invoke: (args) ->
        processedArgs = @argSpec(args)

        if e = processedArgs.error
          return processedArgs

        ret = @impl processedArgs

## The syntax options

### RPN

```forth
    : max       ( a b -- c )
      over over ( a b a b )
      - 0 < if swap then ( max lesser )
      drop
    ;
```

### Prefix kinda

```

    : max 

```
