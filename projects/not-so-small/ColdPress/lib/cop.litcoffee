# ColdPress Object Protocol

    module.exports = ({db, createObject, createMethod}) ->
      COP =
        $: $ = Symbol 'ColdPress Object Protocol'
        db: db

## Object mutation

### Life cycle, inheritance

        lookupId: (id) -> db.lookupId id

        create: (parent = COP.$root ?= COP.lookup '$root') ->
          o = createObject db, parent

        getParent: (o) -> o.getParent()

        setParent: (o, parent) -> o.setParent parent

        getChildren: (o) -> o.getChildren()

        destroy: (o) -> o.destroy()

### Properties

        addProp: (o, name) -> o.addProp name

        getProp: (o, name) -> o.getProp name

        listProps: (o) -> o.listProps()

        delProp: (o, name) -> o.delProp name

### Methods

#### addMethod

... is particularly important as the method wrapper has a lot of work to do:

- at time of add
 - create sandbox
 - compile CoffeeScript to AST
 - modify AST
  - modify Call nodes to turn 'foo args...' into $call foo args...
- before wrapped function
 - update stack
 - init sandbox
  - set $caller et al
- after wrapped function
 - find and save field changes
 - update stack

        addMethod: (o, name, code) ->
          m = createMethod o, name, code
          o.methods[name] = m

        listMethods: (o) ->

        getMethod: (o, name) ->

        matchMethod: (self, definer = self, name, args) ->
          if m = definer.methods[name] and matched = m.match args
            matched
          else if p = COP.getParent definer and
              matched = COP.matchMethod self, p, name, args
            matched
          else
            throw new Error '~methodnf'

        invokeMethod: (stack, method, args) ->

