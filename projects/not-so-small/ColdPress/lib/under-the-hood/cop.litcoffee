# ColdPress Object Protocol

    module.exports = ({getDb, createObject, createMethod}) ->
      COP = ColdPressObjectProtocol =
        $: $ = Symbol 'ColdPress Object Protocol'
        db: db = getDb()

## Object mutation

### Life cycle, inheritance

        lookupId    : (id) -> db.lookupId id

        create      : (parent = COP.$root ?= COP.lookup '$root') -> o = createObject db, parent
        destroy     : (o) -> o[$].destroy()

        getParent   : (o) -> o[$].getParent()
        setParent   : (o, parent) -> o[$].setParent parent
        getChildren : (o) -> o[$].getChildren()

### Properties

        getProp     : (o, name) -> o[$].getProp name
        addProp     : (o, name) -> o[$].addProp name
        delProp     : (o, name) -> o[$].delProp name
        listProps   : (o) -> o[$].listProps()

### Methods

        addMethod: (o, name, code) -> o[$].addMethod name, code

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

      return {COP, ColdPressObjectProtocol}
