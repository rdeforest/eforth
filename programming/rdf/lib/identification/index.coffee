# Hello

class Identified
  @comment: """
    Meta object for managing object identities without
    creating conflicting props.

    Usage:

      foo = new Foo
      myContext = new IdContext

      Identified(foo)
        .addContext myContext
        .ids()

      => [Identifier {context: myContext, idNum: 0, o: foo}]

      myContext.lookup 0
      => foo

      Identified(foo).goingAway()
      myContext.lookup 0
      => undefined

      
  """

  @sym: Symbol 'Identified'

  constructor: (@target) ->
    if ids = @target[Identified.sym]
      return ids

    @target[Identified.sym] = @
    @contexts = []
    @ids = []

  addContext: (context) ->
    @target[Identified.sym].push context

    context.identify @target
    return @

  leaveContext: (ctx) ->
    try
      @target[ctx.sym].id.free()

  goingAway:
    @target[Identified.sym]
      .forEach (ctx) =>
    
class Identifier
  @comment: """
     - exists to
      - allow objects to refer to each other
      - in a consistent way
      - which serializes well
     - has
      - idContext
      - identified object
      - idNum unique within idContext
  """

  constructor: (@idContext, @o, idNum) ->

    # XXX: Bad code smell! Should reconcile IDs automatically.
    #  'requestId' assigns the next available id
    #   'demandId' throws if requested id is not available
    #   'demandId' exists for thawing frozen objects
    if idNum
      request = 'demandId'
    else
      request = 'requestId'

    @idNum = @idContext[request] @o, idNum

    Identified(@o).addId @

  free: -> @idContext.freeId @

class IdContext
  @comment: """
     - exists to
      - give user control of how unique an ID is
     - has
      - known identities
     - does
      - identify (o) -> sets o.id to an Identifier
      - lookup (idNum) -> return o
  """

  constructor: ->
    @known = []

  freeId: (identifier) ->
    if identifier.idContext isnt @
      throw new Error "Identifier trying to free itself from wrong context"

    unless Identified(identifier.o).hasContext @
      throw new Error "Identifier trying to free itself from context it's not from"

    unless @known[idNum = identifier.idNum] is identifier
      throw new Error "Identifier trying to free itself has inconsistent idNum"

    @known[idNum] = undefined

    return @

  validIdNum: (idNum) ->
    ('number' is typeof idNum) and idNum >= 0

  demandId: (id, idNum) ->
    unless @validIdNum idNum
      throw new Error "Not a valid identification number: #{idNum}"

    if @known[idNum] not in [undefined, id.o]
      throw new Error "Demanded id #{idNum} not available"

    @known[idNum] = id
    return idNum

  requestId: (id, idNum) ->
    if @known[idNum]
      idNum = @known.length

    @known[idNum] = id
    return idNum

  identify: (o) ->
    if Identified(o).hasContext @
      throw new Error "Objects may only have one ID per context"

    new Identifier @, o
    return @

  lookupId: (idNum) ->    @known[idNum]
  lookup  : (idNum) -> @lookupId(idNum).o

Object.assign module.exports, { Identifier, IdContext }
