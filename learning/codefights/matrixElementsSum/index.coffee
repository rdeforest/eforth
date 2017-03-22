###

After becoming famous, CodeBots decided to move to a new building and live
together. The building is represented by a rectangular matrix of rooms, each
cell containing an integer - the price of the room. Some rooms are free (their
cost is 0), but that's probably because they are haunted, so all the bots are
afraid of them. That is why any room that is free or is located anywhere below
a free room in the same column is not considered suitable for the bots.

Help the bots calculate the total price of all the rooms that are suitable for
them.

A matrix is an array of rows. Column 'n' is then n'th element of each row.

###

matrixElementsSum = (matrix) ->
  mask = matrix[0].map -> true
  t = 0

  for row in matrix
    for cell, colNum in row
      if cell is 0
        mask[colNum] = false
      else if mask[colNum]
        t += cell

  return t

