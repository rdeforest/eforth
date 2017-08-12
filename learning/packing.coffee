Object.assign module.exports, {PackedItem, PackingGrid}

class PackedItem
  constructor: (@width, @height) ->
    @grid = null
    @area = @width * @height

  placeAt: (grid, x0, y0) ->
    if grid isnt @grid ?= grid
      throw new Error "Already placed"

    try
      [1..@height].map (y) ->
        [1..@width].map (x) ->
          @grid.place @, x0 + x, y0 + y
    catch e
      @remove()

  remove: ->
    if not @grid
      throw new Error "Not placed"

    try
      @grid.purge @
    finally
      @grid = null

class PackingGrid
  constructor: (@width, @height) ->
    @area            = @width * @height

    @contents        = []
    @freeSpaces      = []
    @insertItem      = @contents  .sortedAdder (a, b) -> a.area - b.area
    @insertFreeSpace = @freeSpaces.sortedAdder (a, b) -> a.area - b.area

  purge: (item) ->
    if -1 is idx = @contents.findIndex (i) -> i is item
      @contents.splice idx, 1
      @repack()

  canAdd: (item) ->
    if not @contents
      item.width < @width and item.height < @height
    else
      fits = @freeSpaces.filter (subGrid) -> subGrid.canAdd item
      fits.length and fits

  add: (item) ->
    unless fits = @canAdd item
      throw new Error "item too large"

    @insert item
    @repack()

  repack: ->
    @freeSpaces = [@]

    placeItem = (item) =>
      for area, aidx in @freeSpaces
        if area.canAdd item
          @freeSpaces.splice aidx, 0

          if 0 <= dx = area.width  - item.width
            @insertFreeSpace new PackingGrid dx, area.height

          if 0 <= dy = area.height - item.height
            @insertFreeSpace new PackingGrid area.width, dy

          return true

      throw new Error "Failed to find space for item"

    for item in @contents
      placeItem item
