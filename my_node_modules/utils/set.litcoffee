    module.exports = (opts) ->
      setUnion: setUnion = (union, sets...) ->
        ( for set in sets
            union = union.concat(el for el in set when el not in union))[0]
