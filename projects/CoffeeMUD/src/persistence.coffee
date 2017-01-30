class ObjStore
  fetch: (id) -> # virtual
  create: (persisted) -> # virtual

class InMemoryDB extends ObjStore
  constructor: ->
    @nextId = 0
    @store  = []

  fetch: (id)  ->
    if frozen = @store[id]
      frozen.klass.thaw frozen

  add: (o) ->
    if o.id
      throw new Error "Object already has an ID?!"

    o._db = @
    @store[o.id = @nextId++] = o.freeze()

class Persisted
  constructor: (@db, @implementation) ->
    @db = db.add @

  freeze: ->
    frozen =
      klass: @constructor
      id:    @id

    for name, aspect in @_aspects?()?
      frozen[name] = aspect.freeze()

  thaw: (frozen) ->
    throw new Error "#{@constructor.name} and its parents do not implement the ::thaw virtual method."

module.exports = { Persisted }
