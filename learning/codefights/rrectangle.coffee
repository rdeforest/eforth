ROOT2 = Math.sqrt 2

inside = (a, b, x, y) ->


mappers = (a, b, sign = 1) ->
  deltaTheta = Math.PI / (sign * 4)

  translate: ([x, y]) ->
    #console.log 'txlt', a, b, x, y, sign, ret =
    [x + a / 2 * -sign, y + b / 2 * -sign]
    #ret

  rotate: ([x, y]) ->
    r  = Math.sqrt(x*x + y*y)

    th = (
        if x is 0
          y/Math.abs(y)
        else
          Math.atan(y/x)
      ) + deltaTheta

    #console.log 'rot ', a, b, x, y, r, th#, ret =
    [r * Math.cos(th), r * Math.sin(th)]
    #ret

rectangleRotation = (a, b) ->
  twist = do ->
    {translate, rotate} = mappers a, b,  1
    (x, y) -> rotate translate [x, y]

  untwist = do ->
    {translate, rotate} = mappers a, b, -1
    (x, y) -> translate rotate [x, y]

  [topX, topY] = twist a, b
  topX = Math.ceil topX
  topY = Math.ceil topY
  #console.log topX, topY

  count = 0

  for x in [-topX..topX]
    for y in [-topY..topY]
      if x is 0 and y is 0
        count++
        continue

      [realX, realY] = untwist x, y

      if 0 <= realX <= a and 0 <= realY <= b
        count++
      #else
      #  console.log "not", x, y, realX, realY

  count

Object.assign global, {mappers, rectangleRotation}

(require 'test') [
  [1, 1, 1]
  [6, 4, 23]
], rectangleRotation
