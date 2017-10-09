CELL_SIZE = 16

module.exports.BitField =
class BitField
  constructor: (@size = CELL_SIZE) ->
    @_cells  = Buffer.alloc @size / CELL_SIZE, 0

  updateMinMax: (n, from, to) ->
    if to
      @_minSet = Math.min @_minSet ? n, n
      @_maxSet = Math.max @_maxSet ? n, n
    else if not from
      return
    else
      if n is @_minSet
        if n is @_maxSet
          @_minSet = @_maxSet = undefined
        else
          
      if n is @_maxSet

  addressesInCell: (cell) ->
    if cell < 0 or 'numeric' isnt typeof cell
      throw new Error "Invalid cell index #{cell}"

    from = (1 << (cell * CELL_SIZE)) - 1
    [from .. from + CELL_SIZE]

  addressOf: (n) ->
    throw new Error "negative indexes not supported" if n < 0

    cell = n >> CELL_SIZE
    mask = 1 << (bit = n % CELL_SIZE)

    return {cell, bit, mask}

  _resize: (offset) ->
    console.log "Resizing by #{offset}"
    @_cells = Buffer.from @_cells, 0, @size + offset

    return @

  set: (n) ->
    {cell, mask} = @addressOf n

    @_resize needed if 0 < needed = cell - @_cells.length

    @_cells[cell] |= mask

    @_maxSet = Math.max @_maxSet, n
    @_minSet = Math.min @_minSet, n

    return @

  clear: (n) ->
    return if n > @_maxSet

    {cell, mask} = @addressOf n

    @_cells[cell] &= ~mask

    if n is @_maxSet
      cell-- until cellValue = @_cells[cell]

      @_maxSet = (cell << CELL_SIZE) - 1
      @_maxSet-- until @test @_maxSet

    if n is @_minSet
      cell++ until cellValue = @_cells[cell]

      @_minSet = 

    return @

  maxSet: -> @_maxSet

  toggle: (n) ->
    if n > @_maxSet
      @set n
    else
      {cell, mask} = @addressOf n
      @_cellss[cell] ^= mask

  test: (n) ->
    [cell, mask] = @addressOf n

    @_cells[cell] & mask

BitField::[Symbol.iterator] = ->
  idx = 0

  while idx < @_maxSet
    yield idx if @test idx

    idx++
