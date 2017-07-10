module.exports =
  sudoku = (grid) ->
    valid = (set) ->
      set.length is 9 and -1 is ([1..9].findIndex (i) -> i not in set)

    row = (n) -> grid[n]

    col = (n) -> grid.map (row) -> row[n]

    sqr = (n) ->
      x = n % 3
      y = (n - x) / 3
      [x, y] = [x * 3, y * 3]

      [0..2]
        .map (i) -> grid[y + i][x .. x + 2]
        .reduce (a, b) -> a.concat b

    -1 is [0..8].findIndex (i) ->
        not valid(row i) or
        not valid(col i) or
        not valid(sqr i)
