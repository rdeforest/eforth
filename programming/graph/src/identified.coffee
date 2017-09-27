makeIdentified = (klass) ->
  identifiedClass = new extends klass
    @comment: '''I have a unique ID and my peers can reference me by it, no
                 matter what their class'''
    constructor: ->
      super arguments...

class IdContext
  constructor: (info = {}) ->
    @nextId = 1
    @known  = []

class IdMaker
  constructor: (info = {}) ->
    { @context = new IdContext
    } = info

  getId: ->
    @context.nextId++

  requestId: (id, identified) ->
    if not identified and id?.id
      {id} = identified = id

    if id > 0 and undefined is @context.known[id]
      if identified.id not in [id, undefined]
        throw new Error "Refusing to associate #{id} with object with .id of #{identified.id}"

      @context.known[id] = identified
      identfied.id = id

    Identified.nextId = Math.max(@id, Identified.nextId) + 1

    Identified.known[@id] = @

  destroy: ->
    Identified.known[@id] = undefined
    @id = -@id

  destroyed: -> @id < 0

  lookupId: (id) -> Identified.known[id]

