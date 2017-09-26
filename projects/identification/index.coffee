class Identifier
  constructor: (@idContext, @o, id) ->
    if id
      request = 'demand'
    else
      request = 'request'

    # request will provide an available id
    # demand will throw if supplied id is not available
    # demand exists for thawing frozen objects
    # XXX: Bad code smell! Why are we relying on a value in persistence?
    @id = @idContext[request] @o, id
    @o.id = @

  lookup: (id) -> @idContext.lookup id

  delete:      -> @idContext.freeId @id

class IdContext
  constructor: ->
    @known = []
    @nextId = 1

  freeId: (identifier) ->
    if identifier.idContext isnt @
      throw new Error "Identifier trying to free itself from wrong context"

    if @known[id = identifier.id] is identifier.o
      @known[id] = undefined

  demandId: (subject, id) ->
    if @known[id] isnt undefined
      throw new Error "Demanded id #{id} still in use"

    @known[id] = subject
    @nextId = id + 1 if id > @nextId
    id

  requestId: (subject) ->
    @known[id = @nextId++] = subject
    id

  identify: (o) ->
    if o.id isnt undefined
      throw new Error "Can only add identification to an object with no .id"

    new Identifier @, o

  lookup: (id) -> @known[id]

  # The rules:
  # @id.lookup @id.id === this
  # and @id.id is unique within @id.idContext.known
