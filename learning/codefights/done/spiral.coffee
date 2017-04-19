spiralNumbers = (n) ->
  #matrix = (new Array n).fill(1).map -> (new Array n).fill -1
  matrix = []

  #matrix.toString = ->
  #  @.map((row) ->
  #    row.map (c) -> c.toString().padStart 3
  #       .join ''
  #  ).join '\n'

  #console.log matrix.toString()
  x = 0; y = 0; d = 0

  m = [ [ 1,  0]
        [ 0,  1]
        [-1,  0]
        [ 0, -1] ]

  l = n * 2
  steps = 1
  d = 0

  for i in [1..n*n]
    #console.log matrix.toString() + "\n", x, y, d
    (matrix[y] ||= [])[x] = i++

    if steps++ is l >> 1
      l--
      steps = 1
      d = (d + 1) % 4

    [x, y] = [x + m[d][0], y + m[d][1]]
  
  matrix

#console.log spiralNumbers(3).toString()
#console.log spiralNumbers(4).toString()
#console.log spiralNumbers(5).toString()
