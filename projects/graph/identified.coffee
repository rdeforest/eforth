{ interfaceCheck: ifCheck } = require 'interface-check'

class Interface
  constructor: (definition = {}) ->
    @initDefinition definition

MetaIdentified = (context) ->
  ifCheck context, hasFns:
    requestId: [ obj: (o) -> 'object' is typeof o ]
    fetch: stdIdChk = [ 'id': (id) -> 0 < id < @dbtop ]
    delete: stdIdChk
    set: [
      { id: (id) -> 0 < id < Infinity }
      { obj: (o) -> true }
    ]

  identifiedClass = class
    constructor: (info) ->

class Identified
  @comment: 'I have a unique ID and my peers can reference me by it, no matter what their class'

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
      if ctorTree = ctor.toTree? @
        Object.assign tree, "#{ctor.name}": ctorTree

      if ctor is next = ctor.__proto__.constructor
        return tree

  toString: ->
    yaml.safeDump @toTree()

  @toTree: -> { @id }

  lookupId: (id) -> Identified.known[id]


