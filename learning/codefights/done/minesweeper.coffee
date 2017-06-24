minesweeper = (matrix) ->
  maxY = matrix.length - 1
  maxX = matrix[0].length - 1

  for row, y in matrix
    for cell, x in row
      [ matrix[y - 1]?[x - 1]
        matrix[y - 1]?[x    ]
        matrix[y - 1]?[x + 1]
        matrix[y    ]?[x - 1]

        matrix[y    ]?[x + 1]
        matrix[y + 1]?[x - 1]
        matrix[y + 1]?[x    ]
        matrix[y + 1]?[x + 1]
      ] .filter (t) -> t
        .length

(require './genericTester') [
  [
    [ [ [true, false, false]
        [false, true, false]
        [false, false, false]
      ]
    ]
  [ [1,2,1]
    [2,1,1]
    [1,1,1]]
  ]
], minesweeper
