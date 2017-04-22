## StoredObject

    class StoredObject
      constructor: (@db, @id, @coldObject) ->
        @version = 0
        @parent  = 0
        @props   = {}
        @methods = {}

      destroy: ->
        @db.destroy @id

      setMethod: (name, code) ->
        @methods[name] = code

## DB

The DB handles the object lifecycle, persistence and versioning.

    class ColdDB
      constructor: ->
        @log       = []
        @committed = -1

        @objs   = []
        @nextId = 0

      create: (coldObject, id = @nextId++) ->
        o = new StoredObject @, id, coldObject
        @logChanges {change: 'create', id}
        return o

      lookupId: (id) ->
        if not o = @objs[id]
          throw new Error "~objnf"

        return o

      isValid: (id) ->
        0 <= id <= @nextId - 1 and @objs[id] isnt undefined

      destroy: (id) ->
        o = @lookup id
        @logChanges {change: 'destroy', id}
        @dieing[id] = o
        @objs[id] = null

      commit: ->
        @writeChanges @log[@committed + 1..]

      rollback: ->
        @log.length = @committed + 1

