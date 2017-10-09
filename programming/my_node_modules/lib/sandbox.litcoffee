# What

Turn CoffeeScript 'code' into a function whose version of 'global' is not the
same as the 'real' global, and expose that inner global for manipulation.

# Why

So we can do things like

    ->
      example = exposed fakeGlobal, (args...) ->
        foo is fakeGlobal.foo # => true

Which then allows us to create DSLs which are only present for some functions.

    util = require 'util'
    vm   = require 'vm'
    cs   = require 'coffeescript'

# How

    _addFn = Symbol()

    class Global
    Object.assign Global::, global

    class Sandbox extends Global
      constructor: (definitions) ->
        super()

        vm.createContext @
        @global = @

        for name, def of definitions
          console.log "Adding #{name}"
          if 'function' is typeof def
            console.log "Wrapping function: #{name}"
            @[_addFn] name, def

          else
            @[name] = def

    Sandbox::[_addFn] = (name, fn, options = {}) ->
      switch typeof fn
        when 'string'
          code = cs.compile fn, bare: true

          if 'function' isnt typeof eval code
            throw new Error 'Code is not a function definition'

        when 'function'
          code = "(#{fn.toString()})"

        else
          throw new Error "Cannot contextify #{typeof fn} '#{util.inspect fn}'"

      script = new vm.Script code, options

      @[name] = script.runInContext @
      return @

    db = []

    fakeGlobal =
      new Sandbox {
        cs, vm, db

        processDef: ([name, def]) ->
          name = '$' + name
          def.name = name
          def.id = db.length
          db.push global[name] = def
          return name

        define: (namesAndDefs) ->
          Object
            .entries namesAndDefs
            .map processDef.bind @

        sanity: ->

        test: (code) ->
          console.log "testing #{code}\n..."

          jsCode = cs.compile code, bare: true

          console.log vm.runInContext jsCode, @

          return
      }


    do ->
      fakeGlobal.test "typeof vm"
      fakeGlobal.test """
        define Sys: {}, Root: {}
        $Sys.parent = $Root.id
        {$Sys, $Root}
      """

