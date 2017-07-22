module.exports =
  contoursShifting = (matrix, reverse) ->
    if matrix.length is 1
      return [(shiftEither reverse) matrix[0]]

    {contour, inner} = peel matrix

    shifted = (if reverse then shiftLeft else shiftRight) contour

    if inner.length > 1
      inner = contoursShifting inner, not reverse

    unpeel shifted, inner

Object.assign module.exports,
  shiftLeft   : shiftLeft   = ([first,   rest...]) -> rest.concat first
  shiftRight  : shiftRight  = ([rest..., last   ]) -> [last].concat rest
  shiftEither : shiftEither = (reversed) -> if reversed then shiftRight else shiftLeft

  peel: peel = (matrix) ->
    [top, rest..., bottom] = matrix

    if not bottom
      throw new Error "invalid matrix passed to peel: " + JSON.stringify matrix

    left  = []
    inner = []
    right = []

    for row in rest
      [l, i..., r] = row
      left.push  l
      inner.push i if i.length
      right.push r if row.length > 1

    contour = [].concat top, right, bottom.reverse(), left
    {contour, inner}

  unpeel: unpeel = (contour, inner) ->
    width = 0

    if height = inner.length
      width = inner[0].length

    upperRight = width + 1
    lowerRight = upperRight + height + 1
    lowerLeft  = lowerRight + width + 1

    #console.log {width, height, upperRight, lowerRight, lowerLeft}

    top    = contour[..upperRight]
    middle = inner.map (row, rIdx) -> [contour[contour.length - rIdx - 1], row..., contour[upperRight + rIdx + 1]]
    bottom = contour[lowerRight..lowerLeft].reverse()

    if middle.length
      [top, middle..., bottom]
    else
      [top, bottom]

  contoursShifting: contoursShifting
