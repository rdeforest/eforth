Object.assign module.exports,
  ZIndex: class ZIndex
    constructor: (info = {}) ->
      @dimensions = []
      @entries = new Map

      { dimensions = {}
      } = info

      @addDimension name, info for name, info of dimensions

    addDimension: (name, info) ->
      if entries.length
        throw new Error "Cannot add dimensions after adding entries."

      { from   = 0
        to     = 0
        defVal = 0
      } = info

      @dimensions.push {name, from, to, defVal}
      @getZIndex = ZIndex.makeGetZIndex @

    @makeGetZIndex: (instance) ->
      {dimensions} = instance

      maxCoordRange = Math.max dimensions.map(({from, to}) -> to - from)...
      coordBits = Math.floor Math.log2 maxCoordRange

      # coords = {} is ok because every coordinate has a default value
      (coords = {}) ->
        coords = Object.assign {}, coords

        coords =
          dimensions.map (d) ->
            (coords[d.name] ? d.defVal) - d.from

        zIdx = 0

        for bit in [0 .. coordBits]
          for c, i in coords
            zIdx = zIdx << 1 + c & 1
            coords[i] >>= 1

        zIdx

Object.defineProperty ZIndex::, 'size',
  get: -> @entries.size
