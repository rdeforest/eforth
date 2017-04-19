chessKnight = (cell) ->
  [row, col] = cell
  row = Math.min " abcdefgh".indexOf cell[0]
  col = Math.min parseInt(cell[1])

  row = 9 - row if row > 4
  col = 9 - col if col > 4

  origin = [row, col]
  moves = 2
  for longAxis in [0, 1]
    shortAxis = 1 - longAxis

    for longSign in [-1, 1]
      for shortSign in [-1, 1]
        if 0 < origin[longAxis]  + longSign  * 2 and
           0 < origin[shortAxis] + shortSign * 1
          moves++

  moves

console.log chessKnight 'a1'
console.log chessKnight 'b2'
console.log chessKnight 'g2'
console.log chessKnight 'g8'

#console.log(
#  (for row in "abcdefgh"
#    (for col in "12345678"
#      chessKnight row + col
#    ).join ''
#  ).join '\n'
#)
###
chessKnight = (cell) ->
  x = y = 2

  if cell[0] in ["a", "h"] then x = 0
  if cell[0] in ["b", "g"] then x = 1
  if cell[1] in ["1", "8"] then y = 0
  if cell[1] in ["2", "7"] then y = 1
  if x+y is 0 then return 2
  return (x+y)*2

# chessKnight = (cell) ->
#   [row, col] = cell
#   row = Math.min " abcdefgh".indexOf cell[0]
#   col = Math.min parseInt(cell[1])
# 
#   row = 9 - row if row > 5
#   col = 9 - col if col > 5
# 
#   row = Math.min 3, row
#   col = Math.min 3, col
# 
#   [row, col] = [col, row] if row < col
# 
#   return (row + 1) * ((col + 1) >> 1) if col % 2
#   return row + 2 if row < 3
#   return 6
# 
# chessKnight = (cell) ->
#   [row, col] = cell
#   row = " abcdefgh".indexOf cell[0]
#   col = parseInt cell[1]
#   row = 9 - row if row > 4
#   col = 9 - col if col > 4
# 
#   moves = [
#     [2, 3, 4, 4]
#     [3, 4, 6, 6]
#     [4, 6, 8, 8]
#     [4, 6, 8, 8]
#   ]
#   return moves[row - 1][col - 1]

# 
# 
# 
# if false
#   row = " abcd".indexOf row
#   if row > col then [row, col] = [col, row]
#   switch
#     when row > 2             then 8
#     when row > 1 and col > 2 then 6
#     when row > 1 and col > 1 then 4
#     when             col > 2 then 4
#     when             col > 1 then 3
#     else                          2
# 
###
