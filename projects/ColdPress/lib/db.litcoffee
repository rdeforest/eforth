## DB

The DB handles the object lifecycle, including persistence and versioning.

    class ColdDB
      constructor: ->
        @log = []
        @current = {}
        @_initMinimal()

      _initMinimal: ->
        sys = @create()
        root = @create()

        @addParent sys, root

      snapshot: ->
        snap = Object.assign {}, @current

      create: ->
        o = new ColdObject
        @logChanges [ { newObject: o, id: o.id } ]
        return o

      lookup: (id) ->
        if not o = @objs[id]
          throw new Error "~objnf"

        return o

      destroy: (id) ->
        o = @lookup id
        @dieing[id] = o
        @objs[id] = null

