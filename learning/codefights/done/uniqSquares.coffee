differentSquares = (matrix) ->
  seen = {}

  for row, y in matrix
    for cell, x in row when undefined not in [matrix[y + 1], row[x + 1]]
      square = [matrix[y    ][x..x + 1]...
                matrix[y + 1][x..x + 1]...]

      s = square.join " "
      seen[s] = 1

  Object.keys(seen).length

matrixa = [[1,2,1], [2,2,2], [2,2,2], [1,2,3], [2,2,1]]

(require './done/genericTester') [
  [[matrixa], 6]
], differentSquares
