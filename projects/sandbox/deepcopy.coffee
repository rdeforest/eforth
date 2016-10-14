module.exports =
  deepCopy = (o) ->
    deepCopyObject = deepCopyArray = null
    seen = new Map

    _deepCopy = (o) ->
      switch
        when seen and seen.has o  then seen[o]
        when Array.isArray o      then deepCopyArray  o
        when 'object' is typeof o then deepCopyObject o
        else o

    deepCopyObject = (o) ->
      seen[o] = copy = {}

      for k, v of o
        copy[k] = deepCopy o, seen

      copy

    deepCopyArray = (o) ->
      seen[o] = copy = []

      for v, k of o
        copy[k] = deepCopy o, seen

      copy

    _deepCopy o
