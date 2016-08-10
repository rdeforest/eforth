unique = (fn, idFn) ->
  built = {}

  (args...) ->
    id = idFn args...

    built[id] or= fn args...

memoize = (fn) ->
  savedResults = {}

  (args...) ->
    savedResults[JSON.stringify args] or= fn args...

singleton = (fn) ->
  singleton = null
  firstTime = true

  (args...) ->
    if firstTime
      singleton = fn args...
      firstTime = false

    singleton

uniqueName = (fn) ->
  unique fn, (args...) -> {name} = args[0]

module.exports = {unique, memoize, singleton}
