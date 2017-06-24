#assert = require 'assert'

ok = (l) ->
  l.slice()
    .sort()
    .filter (n, i) -> n isnt i + 1
    .length is 0

square = (grid, n) ->
  x = n % 3
  y = (n - x) / 3
  [x, y] = [x * 3, y * 3]
  return [].concat(
    grid[y    ][x..x+2]
    grid[y + 1][x..x+2]
    grid[y + 2][x..x+2]
  )

row = (grid, n) -> grid[n]
col = (grid, n) -> grid.map (row) -> row[n]

sudoku = (g) ->
  grid = g.slice()
  for i in [0..8] when not (ok(square(grid, i)) and ok(row(grid, i)) and ok(col(grid, i)))
    return false
    #if ok square
    #switch
    #  when not ok s = square(grid, i) then console.log "square #{i}: #{s}"; return false
    #  when not ok s = row(grid, i)    then console.log "row    #{i}: #{s}"; return false
    #  when not ok s = col(grid, i)    then console.log "col    #{i}: #{s}"; return false
    #assert.deepEqual g, grid
  true
   
test1 = [ [1,3,2,5,4,6,9,8,7],
          [4,6,5,8,7,9,3,2,1],
          [7,9,8,2,1,3,6,5,4],
          [9,2,1,4,3,5,8,7,6],
          [3,5,4,7,6,8,2,1,9],
          [6,8,7,1,9,2,5,4,3],
          [5,7,6,9,8,1,4,3,2],
          [2,4,3,6,5,7,1,9,8],
          [8,1,9,3,2,4,7,6,5] ]

console.log sudoku test1

#Object.assign module.exports, {test1, sudoku, ok, row, col, square}
