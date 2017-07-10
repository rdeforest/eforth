module.exports =
  shiftLeft  : ([first,   rest...]) -> rest.concat first
  shiftRight : ([rest..., last   ]) -> [last].concat rest

  peel: (matrix) ->
    left  = []
    inner = []
    right = []

    [top, rest..., bottom] = matrix

    for row in rest
      [l, i..., r] = row
      left.push  l
      inner.push i if i.length
      right.push r if row.length > 1

    contour = [].concat top, right, bottom.reverse(), left
    {contour, inner}

  unpeel: (contour, inner) ->
    height = inner.length
    width = inner[0].length

    upperRight = width + 1
    lowerRight = upperRight + height + 1
    lowerLeft  = lowerRight + width + 2

    console.log width, height, upperRight, lowerRight, lowerLeft

    top    = contour[..upperRight]
    right  = contour[upperRight + 1..lowerRight]
    bottom = contour[lowerRight + 1..lowerLeft].reverse()
    left   = contour[lowerLeft + 1..]

    middle = inner.map (row, i) -> [].concat left[i], row, right[i]

    [].concat (
      top
      middle
      bottom
    )

  ###
  contoursShifting: contoursShifting = (matrix, reverse) ->
    width = matrix[0].length

    switch height = matrix.length
      when 1
      when 2
      else
        {contour, inner} = peel matrix
        inner = contoursShifting inner, not reverse

    contour =
      if reverse
        shiftLeft contour
      else
        shiftRight contour
  ###
