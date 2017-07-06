module.exports =
  shiftLeft: ([first, rest...]) -> rest.concat first
  shiftRight: ([rest..., last]) -> [last].concat rest

  top:    (matrix, reverse) ->
    [row0, [upperLeft, cells..., upperRight], rows...] = matrix

    if reverse
      row0.pop()
      row0.unshift upperLeft
    else
      row0.shift()
      row0.push upperRight

    row0

  bottom: (matrix, reverse) ->
    [rows..., [lowerLeft, cells..., lowerRight], rowN] = matrix

    if reverse
      rowN.shift()
      rowN.push lowerRight
    else
      rownN.pop()
      rowN.unshift lowerLeft

  middle: (matrix, reverse) ->
    [[upperLeft, top..., upperRight], middle..., [lowerLeft, bottom..., lowerRight] = matrix

    left = []
    inner = []
    right = []

    for [first, others..., last] in middle
      left.push first
      inner.push others
      right.push last

    if reverse
      left.shift()
      left.push lowerLeft
      right.pop()
      right.unshift upperRight
    else
      left.pop()
      left.unshift upperLeft
      right.shift()
      right.push lowerRight

    countoursShifting inner, not reverse
      .map (row, y) -> [left[y], row..., right[y]]

  contoursShifting: contoursShifting = (matrix, reverse) ->
    height = matrix.length
    width  = matrix[0].length

    if height + length < 3
      return matrix

    if height is 1
      row = matrix[0]
      [ if reverse
          shiftRight row
        else
          shiftLeft row
      ]
    else if width is 1
      if reverse
        shiftRight matrix
      else
        shiftLeft matrix
    else
      [].concat(
        top    matrix, reverse
        middle matrix, reverse
        bottom matrix, reverse
      )
