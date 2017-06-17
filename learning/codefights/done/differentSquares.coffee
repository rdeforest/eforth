# Possible performance opportunity
makeSquare = ([a,b,c,d]) -> a * 1000 + b * 100 + c * 10 + d

module.exports = differentSquares = (grid) ->
  seen = []
  count = 0

  prevRow = grid[0]

  for row in grid[1..]
    prevCell = row[0]
    
    for cell, x in row[1..]
      square = makeSquare prevRow[x..x+1].concat [prevCell, cell]

      #console.log square

      unless seen[square]
        count++
        seen[square] = true

      prevCell = cell
    prevRow = row

  count
