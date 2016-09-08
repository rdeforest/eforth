This is our clever way of protecting the "popSym secret":

    define = undefined # Hilarious, right?!

    require './nsrequire'

The nsrequire module will in turn require './nsdef' and invoke it with the
tree symbol. If any other module already required 'nsrequire' previously this
will already have happened and 'define' will already be set.

(We're counting on NodeJS to not re-execute the module on redundant requires.)

    module.exports = (sym, populate) ->
      define or= (modInfo, modGen) ->
        Tree::[sym] = populate

        tree = new Tree modInfo, modGen
          .startImporting()
          .then (imported) ->
            def.runModGen imported

    class Tree
      constructor: (modInfo) ->
        if not @actualMod = modInfo.module
          throw new Error 'definition needs a module object to wrangle.'

        @imports = modInfo.imports ? {}
        @importing = undefined
        @imported = {}
        @doneImporting = false

      doneImporting: (imported) ->
        @doneImporting = true

      asyncImport: ([modName, alias]) ->

      interpretImport: (modName, alias) ->
        if not alias
          return

        if 'object' is typeof alias
          if 'commonjs' is modName
            return @importCommonJSpaths modName, alias
          else
            return @importPaths         modName, alias

        if alias is yes # same as (alias and 'boolean' is typeof alias)
          alias = modName

        if 'string' is t = typeof alias
          @imported[alias] = require modName
        else
          console.warn "Not sure what to do with import alias type of '#{t}'"

      startImporting: ->
        requested = @interpretImports()
        @importing = Promise.resolve []

        loop
          {value: modRequest, done} = requested.next()

          if done
            break

          @importing = @importing.then (accumulated) ->
            accumulated.push @asyncImport modRequest

        @importing = @importing
          .then (accumulated) ->
            @doneImporting accumulated

Put module names directly on their parents so that foo.bar.baz works as
expected. The alternative (foo.branch.bar.branch.baz) is pointless. We just
have to prohibit module names which override inherited properties.

We store the dict of loaded modules in [branches] so that a tree could have a
branch named 'branches' without conflicting.

    branches = Symbol 'branches'

    populate = ([name, rest...]) ->
      if not branch = @[branches][name]
        if @[name]
          throw new Error 'name conflict'

        branch = @[name] = @[branches][name] = graft this, name

        if rest.length
          return branch[treeSym] rest

      branch


    (require './nsdef') populate, nsRequire.populate

