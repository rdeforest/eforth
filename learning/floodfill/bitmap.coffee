class Bitmap
  constructor: (opts = {}) ->
    { @data         = []
      @xMin         = 0
      @yMin         = 0
      @xMax         = 0
      @yMax         = 0
    } = opts

  _growX: (toInclude) ->
    return if @xMin <= toInclude <= @xMax

  _growY: (toInclude) ->
    return if @xMin <= toInclude <= @xMax

  _coordsToIdx: (x, y) -> [x + @xMin, y + @yMin]

  _get: ([x, y]) -> @data[@_coordsToIdx x, y]

  get: (x, y) ->
    @_growX x

    _get x, y

  set: (x, y, value) ->
    @_growX x
    @_growY y

    @data[@_coordsToIdx x, y] = value
