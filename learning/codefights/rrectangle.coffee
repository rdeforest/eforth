rectangleRotation = (a, b) ->
  {cos, sin, sqrt, atan, PI} = Math
  [a, b] = [b, a] if b < a
  [a2, b2] = [a / 2, b / 2]

  rotate = (x, y, deg) ->
    rad = deg / 180 * PI
    r = sqrt x * x + y * y
    angle = atan(y/x) + rad
    [r * cos(angle), r * sin(angle)]

  [X, Y] = rotate a2, b2, 45
  Y = Math.floor Y

  count = 0

  for y in [-Y..Y]
    for x in [-Y..Y]
      if x is 0 and y is 0
        count++
        continue
      [x2, y2] = rotate x, y, -45

      count++ if (-a2 <= x2 <= a2) and (-b2 <= y2 <= b2)

  count

 (require 'test') [
   [2, 2, 5]
   [6, 4, 23]
   [30, 2, 65]
   [8, 6, 49]
   [16, 20, 333]
 ], rectangleRotation
