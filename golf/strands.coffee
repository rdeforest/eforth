# Cooperative multi-tasking a la MOO and ColdMUD

###

Hoping to add 'suspend', 'resume', etc.

###

newFn = (def) ->
  for name, method of def
    return {name, method}

module.exports =
  class Strand extends Function
    @newFunctions: [
      newFn suspend: (millis) ->
        response = yield suspend: millis


      newFn resume: (arg) ->
      newFn returnFrom: (fn) ->
      newFn resumableThrow: (args...) ->
      newFn resumableTry: (fn, catcher ->, finalizer ->) ->
    ]

    @newFunctionNames: ->
      Strand.newFunctions.map (fn) -> fn.name

    @bindNewFunctions: (instance) ->
      Strand.newFunctions.map (fn) -> fn.method.bind instance

    constructor: (args..., body) ->
      super (Strand.newFunctionNames()..., args..., body) ->

    apply: (thisArg, args = []) ->
      super thisArg, [Strand.newFunctions(@)..., args...]

    call: (thisArg, args...) ->
      super thisArg, Strand.newFunctions(@)..., args...
