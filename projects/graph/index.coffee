moment   = require 'moment'
Bitfield = require 'bitfield'
yaml     = require 'js-yaml'

looped   = Symbol 'looped'

Bitfield::length = ->
  len = 8 * @buffer.length

  for bit in [len .. 0] when @get bit
    return bit

Bitfield::[Symbol.iterator] = ->
  yield idx for idx in [0..@length()] when @get idx

class Identified
  @comment: 'I have a unique ID and my peers can look me up by it, no matter what their class'

  @nextId: 1
  @known: []

  constructor: (info = {}) ->
    { @id = Identified.nextId
    } = info

    Identified.nextId = Math.max(@id, Identified.nextId) + 1

    Identified.known[@id] = @

  toTree: ->
    tree = {}
    ctor = @constructor

    loop
      tree[ctor.name] = ctor.toTree? @

      if ctor is next = ctor.__proto__.constructor
        return tree

  toString: ->
    yaml.
    @_addToString '{}',
      Identified: {@id}

  _addToString: (parents, self) ->
    JSON.stringify Object.assign JSON.parse(parents), self

  lookupId: (id) -> Identified.known[id]

class Vertex extends Identified
  @comment: 'I am the source or destination of a relation'

  constructor: (info = {}) ->
    super arguments...

    { @name
      @description
      @created = moment()
    } = info

    @in  = new Bitfield 64, grow: Infinity
    @out = new Bitfield 64, grow: Infinity

  inbound:  -> (@lookupId id) for id from @in
  outbound: -> (@lookupId id) for id from @out

  peers: (direction) ->
    inspector =
      switch direction
        when 'inbound'  then (rel) -> rel.from
        when 'outbound' then (rel) -> rel.to
        else throw new Error "There is no such relation direction as '#{direction}'"

    for rel in @[direction]()
      @lookupId inspector rel

  traverse: (linkSelector = ((dir, edge) -> true), visitor, seen = []) ->
    return looped if @ in seen
    seen.add @

    try
      ret = visitor @, seen

      return ret if ret instanceof Error

    catch e
      return e

    for rel in ['in', 'out']
      for refId from @[rel] when linkSelector rel, ref = @lookupId refId
        ref.traverse relationTypes, visitor, seen

  toString: ->
    inbound   = (id for id from @in)
    outbound  = (id for id from @out)

    @_addToString super(),
      Vertex: {@name, @description, @created, inbound, outbound}

  destroy: ->
    for direction in ['inbound', 'defines', 'outbound']
      rel.disconnect() for rel in @[direction]()

class Edge extends Vertex
  @comment: 'I relate two Vertexes, either of which might also be an Edge'

  constructor: (info = {}) ->
    super arguments...

    { @from, @to } = info

    @from.out      .set @id, true if @from
    @to  .in       .set @id, true if @to

  toString: ->
    @_addToString super(),
      Edge: {@from, @to}

  disconnect: ->
    @from.out      .set @id, false
    @to  .in       .set @id, false
    @def .instances.set @id, false

# ----------------------------------------

# Creates an instance of Vertex and wraps it in a function used below.

makeVertex = (name, description) ->
  vertex = new Vertex {name, description}

  self =
  Object.assign ((edgeBuilder) -> edgeBuilder self),
    Name  : name
    vertex: vertex

  self

makeVertex.comment = """
    See makeEdge for the big picture. The small picture is that I wrap a
    Vertex in a function which conforms to the expectations of the function
    created by makeEdge.
  """

makeEdge =
  (edgeName) ->
    ({vertex: to}) ->
      ({vertex: from}) ->
        new Edge {name: edgeName, from, to}

makeEdge.comment = """
    Takes an edge type and returns a function which
      takes a destination and returns a function which
        takes a source and connects the source to the destination via the edge type
          and is called by the first word in the sentence
        and is called by the second word in the sentence
      and is the second word in the sentence

        from via to

    is also

        from(via(to))

    'via(to)' is a partial application which is invoked by 'from' with itself.

    In makeVertex this partial application is called 'edgeBuilder'.
  """

fruit  = makeVertex 'fruit'
banana = makeVertex 'banana'
isa    = makeEdge   'isa'

banana isa fruit

Identified.known.forEach((i) -> console.log JSON.parse i.toString())
