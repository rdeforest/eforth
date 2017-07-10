module.exports =
  minesweeper = (matrix) ->
    neighbors = (x, y) ->
      set = []

      (for  i in [x - 1 .. x + 1] when 0 <= i < matrix[0].length
        for j in [y - 1 .. y + 1] when 0 <= j < matrix.length and (i isnt x or j isnt y)
          matrix[j][i]
      ).reduce (a, b) -> a.concat b

    matrix.map (row, y) ->
      row.map (cell, x) ->
        neighbors x, y
          .filter (t) -> t
          .length
