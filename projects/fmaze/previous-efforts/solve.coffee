maze = require './maze'

{isConnected, connect, trace, boxMaker} = maze

a = boxMaker 'a'
b = boxMaker 'b'
c = boxMaker 'c'

connect    0, 14, 15, a 0
connect    1, a 3
connect    2, 11, a 4, b 6, c 0
connect    3, b 0

connect    4, b 3
connect    5, b 7
connect    6, a 2, c 5
connect    7, 9, 12, a 10

connect    8, b 2
connect   10, a 13

connect a  7, b 15
connect a  8, c 12
connect a  9, a 15
connect a 11, "minus"

connect b 10, c 3
connect b 13, c 14

connect c 6, c 7
connect c 9, "plus"

# Can't break this down into smaller pieces
trace 0, a 0,
      [0, 15]
      a 15, a 9
      [9, 7]
      a 7, b 15
      [15, 0]
      b 0, 3

trace 0, a 0,
      [0, 3]
      a 3, 1

trace 3, b 0,
      [0, 3]
      b 3, 4

trace 0, 3, 4

trace 0, a 0,
      [0, 4]
      a 4, 2

trace 0, c 0,
      [0, 3]
      c 3, b 10
      [10, 7]
      b 7, 5


