arrayChange = (input) ->
  min = input[0] + 1
  bumps = 0
  bumped = 0

  for n,i in input[1..]
    diff = min - n

    if diff > 0
      bumps += diff
      min++

    else
      min = n + 1

  bumps

module.exports = arrayChange

require('./genericTester') [
  [[[1,1,1]], 3]
  [[[-1000, 0, -2, 0]], 5]
], arrayChange
