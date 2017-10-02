CELL_SIZE = 32

module.exports =
class BitField
  constructor: (@size = CELL_SIZE) ->
    @_field = Buffer.alloc @size / CELL_SIZE, 0

  addressOf: (n) ->
    throw new Error "negative indexes not supported" if n < 0

    cell = n >> CELL_SIZE
    bit  = n  % CELL_SIZE
    mask = 1 << bit
    {cell, bit, mask}

  _resize: (offset) ->
    @_field = Buffer.from @_field, 0, @size + offset

  set:       (n) ->
    {cell, mask} = @addressOf n

    @_resize needed if 0 < needed = cell - @_field.length

    @_field[cell] |= mask

  clear:     (n) ->
    [cell, mask] = @addressOf n

    return if cell >= @_field.length

    @_field[cell] &= ~mask

  toggle:    (n) ->
    if @test n
      @clear n
    else
      @set n

  test:      (n) ->
    [cell, mask] = @addressOf n
    @_field[cell] & mask

