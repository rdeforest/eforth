module.exports =
  starRotation = (matrix, width, center, t) ->
    t = t + 64 while t < -64
    t = t +  8 while t <   0

    return matrix unless (t = t % 8) > 0

    cos = [1,  1,  0, -1, -1, -1,  0,  1]
    sin = [0,  1,  1,  1,  0, -1, -1, -1]

    angleOf = (x, y) ->
      a = 0

      if y < 0 or (y is 0 and x < 0)
        y = -y
        x = -x
        a += 4

      if y > 0
        a++
        if x <= 0 then a++
        if x <  0 then a++

      a

    rotate = (dx, dy, t) ->
      r = Math.max dx, dy, -dx, -dy
      a = angleOf dx, dy

      a = (64 + a + t) % 8

      [r * cos[a], r * sin[a]]

    Object.assign global, {angleOf, rotate, starRotation, sin, cos}

    newmatrix = matrix.map (row) -> row.slice()

    radius = width >> 1

    [cy, cx] = center

    for dy1 in [-radius .. radius]
      for dx1 in [-radius .. radius] when (dx1 or dy1) and ((0 in [dx1, dy1]) or dx1 in [dy1, -dy1])
        [dx2, dy2] = rotate dx1, dy1, t

        [x1, y1] = [dx1 + cx, dy1 + cy]
        [x2, y2] = [dx2 + cx, dy2 + cy]

        newmatrix[y2][x2] =
           matrix[y1][x1]
    
    newmatrix
