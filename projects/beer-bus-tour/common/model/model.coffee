module.exports =
  class Model
    constructor: (@def = {}) ->
      @def.version or= [0, 0, 1]
      @schema = @deriveSchema

    # This would still work if versions were strings :)
    sameVersionAs: (other) ->
      not @def.version.find (v, i) -> other[i]? isnt v

    upgradeStorage: (storedData) ->
      return null if @sameVersionAs storedData

      updatedData = super

      if 'function' is typeof @migrator
        @migrator updatedData or storedData
