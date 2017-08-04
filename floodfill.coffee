# Solving Bruce's flood-fill interview question

# Given a matrix, a starting location and a fill color,
# change all pixels of the same color as the origin with the fill color.

class FloodFiller
  constructor: (@matrix) ->
    unless  Array.isArray(@matrix) and
            ((@height = @matrix.length   ) > 0) and
            ((@width  = @matrix[0].length) > 0) and
            -1 is (@matrix.findIndex (row) -> row.length isnt @matrix[0].length)

      throw new Error "Argument to #{@constructor.name} constructor is not a rectangular matrix"

  @fill: (matrix, x, y, fillColor) ->
    filler = new FloodFiller
    replacedColor = @get matrix, x, y

directions = [
  {dx:  1, dy:  0, flag: 1}
  {dx:  0, dy:  1, flag: 2}
  {dx: -1, dy:  0, flag: 4}
  {dx:  0, dy: -1, flag: 8}
]

floodFill = (matrix, originX, originY, fillColor) ->
  get = (x, y) -> matrix[y]?[x]
  put = (x, y) -> matrix[y][x] = fillColor

  return unless height = matrix.length and
                width  = matrix[0].length and
                'number' is typeof originColor = get originX, originY

  pending = [{x: originX, y: originY, dirMask: 0xF}]

  while pending.length
    {x, y, dirMask} = pending.pop()
    put x, y

    for dir in directions when dirMask & dir.flag
      {dx, dy} = dir

      if dx
        (put x, y) while originColor is get x += dx, y
      else
        (put x, y) while originColor is get x += dx, y

      
