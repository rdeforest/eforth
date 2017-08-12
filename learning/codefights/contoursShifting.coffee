
# https://codefights.com/arcade/code-arcade/waterfall-of-integration/LfP67YRDw2rxoLmeP

class MatrixRow
  constructor: (@cells) ->
    @width = @cells.length
    @cellWidth = Math.max (@cells.map (c) -> c.toString().width)...

class Matrix
  constructor: (@rows) ->
    if not (@height = @rows.length and @width = @rows[0].length)
      throw new Error "Null matrix not implemented"

    for row in @rows
      width = row.length

    if @height = @rows.length
      @width = @rows[0].width

      if -1 isnt @rows[1..].findIndex ((row) -> row.length isnt @width)
        throw new Error "non-rectangular matrix"

    {@coutour, inner} = peel @rows

    if inner.length and inner[0].length
      @inner = new Matrix inner

  toString: ->
    @rows.map @_rowToString
         .join '\n'

  shiftLeft   : ([first,   rest...]) -> [rest..., first]
  shiftRight  : ([rest..., last   ]) -> [last,  rest...]

  shift: (shiftLeft) ->
    (({ false : @shiftRight
        true  : @shiftLeft
    })[not not shiftLeft]).call @

showContour = (contour, width, height) ->
  inner = [1..height].map -> [1..width].map -> '.'
  showMatrix 4, unpeel contour, inner

class Contour extends Matrix
  constructor: (@top, @middle, @bottom) ->
    @cells  = top
    @height = 1
    @width  = top.length

    middle  = false unless middle?.length
    bottom  = false unless bottom?.length

    if middle
      @height += middle.length
      @cells = @cells.concat middle.map (r) -> r[-1..][0]

    if bottom
      @cells = @cells.concat bottom.reverse()
      @height++

    if middle
      @cells = @cells.concat middle.reverse().map (r) -> r[0]

  toString: ->
    rows = [@top]

    if @middle
      rows = rows.concat

  @peel: (matrix) ->
    [top, middle..., bottom] = matrix

    if not bottom
      return new Contour top
    else

    left  = []
    inner = []
    right = []

    for row in rest
      [l, i..., r] = row
      left.unshift l
      inner.push i if i.length
      right.push r if row.length > 1

    contour = [].concat top, right, bottom.reverse(), left
    {contour, inner}

unpeel = (contour, inner) ->
  width = 0

  if height = inner.length
    width = inner[0].length

  upperRight = width + 1
  lowerRight = upperRight + height + 1
  lowerLeft  = lowerRight + width + 1

  top    = contour[..upperRight]
  middle = inner.map (row, rIdx) -> [contour[contour.length - rIdx - 1], row..., contour[upperRight + rIdx + 1]]
  bottom = contour[lowerRight..lowerLeft].reverse()

  if middle.length
    [top, middle..., bottom]
  else
    [top, bottom]

# de/re-construct

# rotation

# implementation

module.exports = contoursShifting =
  (matrix, reverse = true) ->
    #showMatrix 4, matrix

    if not (matrix.length and matrix[0].length)
      # SHOULD NEVER HAPPEN, but whatever
      return matrix

    row1 = matrix[0]

    if matrix.length is 1
      if row1.length is 1
        return matrix
      else
        return [(shiftEither reverse) row1]

    if row1.length is 1
      return shiftEither reverse matrix

    {contour, inner} = peel matrix
    #showContour contour, (inner[0]?.length ? 0), inner.length

    shiftedContour = (shiftEither reverse) contour
    shiftedInner   = contoursShifting inner, not reverse

    shifted = unpeel shiftedContour, shiftedInner
    #showMatrix 4, shifted
    shifted

# "sharing" lol

Object.assign contoursShifting, {
    shiftLeft, shiftRight, shiftEither
    peel, unpeel, contoursShifting
    showMatrix, showContour
}
