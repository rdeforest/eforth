# Solving Bruce's flood-fill interview question

# Given a matrix, a starting location and a fill color,
# change all pixels of the same color as the origin with the fill color.

validate = (matrix) ->
  switch
    when not height = matrix.length
      throw new Error "invalid matrix: zero height"

    when not width = matrix[0].length
      throw new Error "invalid matrix: zero width"

    when -1 < matrix[1..].findIndex((row) -> row.length isnt width)
      throw new Error "invalid matrix: not a rectangle"

  matrix = matrix[..]
  matrix.get = (x, y   ) -> @[y]?[x]
  matrix.put = (x, y, c) -> @[y][x] = c

  {width, height, matrix}

directions = [
  {x:  1, y:  0}
  {x:  0, y:  1}
  {x: -1, y:  0}
  {x:  0, y: -1}
]

fill = (matrix, x, y, newColor) ->
  {width, height, matrix} = validate matrix

  unless 0 <= x <= width
    throw new Error "x #{x} out of range 0 .. #{width}"

  unless 0 <= y <= width
    throw new Error "y #{y} out of range 0 .. #{height}"

  if newColor is originalColor = matrix.get x, y
    return matrix[..]

  branches = [{x, y}]

  while branches.length
    {x, y} = branches.pop()

    matrix.put x, y, newColor

    moreBranches = (
      directions
        .map (dir) -> x: x + dir.x, y: y + dir.y
        .filter ({x, y}) -> originalColor is c = matrix.get x, y
    )

    if moreBranches.length
      branches.push moreBranches...

    console.log branches

  matrix[..]

show = (matrix) ->
  for row in matrix
    console.log row.join ""

fillTester = ->
  global.testMatrix =
    [0..9].map (n, y) ->
      [0..9].map (n, x) ->
        if (x % 4) and (y % 4)
          0
        else
          1

  show testMatrix
  fill testMatrix, 1, 1, 2
  fill testMatrix, 4, 4, 3
  show testMatrix

module.exports = {
  fillTester, show, fill, validate, directions
}
