# Hey Robert! You were thinking about doing some weird MUD experiment?
# I guess?

R  = require 'ramda'

cs = require 'coffee-script'

nonWordString   = /\s+/
isFunctionDef   = R.match /// ^ \s* ( [(] [^)]* [)] \s*)?  -> ///
compileFunction = R.curry cs.eval

initState =
  objects : [ true, true ]
  parents : [ [1], [0] ]
  methods : [ {}, {} ]
  vars    : [ {}, {name: null} ]
  data    : [
      [{}, {name:  'sys'}]
      [{}, {name: 'root'}]
    ]
  names   : sys: 0, root: 1



ancestors = (state, id) ->
  parents = []

  for parent in state.parents[id]
    for ancestor in ancestors parent when ancestor not in parents
      parents.push ancestor

  parents


createObject = (prevState, action) ->
  id = prevState.length

  { parents = [1]
    methods = {}
    vars    = {}
  } = action

  newState =
    objects: R.push prevState.objects, true
    parents: R.push prevState.parents, parents
    methods: R.push prevState.methods, methods
    vars   : R.push prevState.vars   , vars

  data = []
  for parentId in ancestors id
    data[parentId] = {}

  newState.data = R.push prevState.data, data
  newState
   
