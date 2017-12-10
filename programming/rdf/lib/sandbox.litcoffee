# What

Turn CoffeeScript 'code' into a function whose version of 'global' is not the
same as the 'real' global, and expose that inner global for manipulation.

# Why

So we can do things like

    ->
      fakeGlobal = foo: Symbol()

      example = exposed fakeGlobal, (args...) ->
        foo is fakeGlobal.foo # => true

Which then allows us to create DSLs which are only present in some scopes
without having to declare the exported symbols in the destination as well. 

## Yeah but... why is that a good idea?

To explain why, I have to first talk about why not.

Importing a module's exports into the local namespace gives a potentially
untrusted external dependency a way to inject code into the 'trusted' local
namespace.

But the fix for this is to require the local context to specify the names of
the variables which will refer to the imported objects. The fix certainly
solves the security problem, but it creates an annoyance:

_(exporter)_

    Object.assign exports,
      foo: 'bar'
      baz: 'bumble'


_(importer)_

    {foo, baz} = require 'exporter'

In other words, the consumer must ALWAYS _explicitly_ declare how the imported
module will map to the local namespace. Certainly this is a good idea in
"principle", but it's also _so annoying_.

In practice, there are packages which can be trusted not to export any
surprises. In fact, some modules (chai.js, for example) "monkey patch" global
objects to extend the language/VM.

This is _slightly_ more invasive than I want. I kinda like how Perl, Ruby and
Crystal do it, where imports of arbitrary exports only modify the _current_
namespace.

# How

    util = require 'util'
    vm   = require 'vm'
    cs   = require 'coffeescript'

    _addFn = Symbol()

    class Global
    Object.assign Global::, global

    class Sandbox extends Global
      constructor: (definitions) ->
        super()

        vm.createContext @
        @global = @

        for name, def of definitions
          if 'function' is typeof def
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

    ->
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


    ->
      fakeGlobal.test "typeof vm"
      fakeGlobal.test """
        define Sys: {}, Root: {}
        $Sys.parent = $Root.id
        {$Sys, $Root}
      """

    Object.assign module.exports, { Sandbox }

