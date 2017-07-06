module.exports =
  shift: shift = (path, dir) ->
    return path unless dir

    if dir > 0
      path[dir..].concat path[0..dir - 1]
    else
      path[..path.length + dir - 1].concat path[path.length + dir..]

  concat: concat = (a, b) -> a.concat b

  contoursShifting: contoursShifting = (matrix) ->
    length = matrix.length
    width  = matrix[0].length

    top    = (i) ->  [i     .. width  - i    ].map (x) -> [i, x]
    right  = (i) ->  [i + 1 .. height - i - 1].map (y) -> [y, width - i]
    bottom = (i) -> ([i     .. width  - i    ].map (x) -> [height - i, x]).reverse()
    left   = (i) -> ([i + 1 .. height - i - 1].map (y) -> [y, i]).reverse()

    iContour = (i) ->
      [].concat (
        top    i
        left   i
        right  i
        bottom i
      )

    for k in [0..Math.min(length, width)

    Object.assign global, {top, left, right, bottom, iContour, matrix, length, width}

