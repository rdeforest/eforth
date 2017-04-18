arrayMaximalAdjacentDifference = (inputArray) ->
  max = 0
  m = inputArray[0]
  for n in inputArray[1..]
    max = Math.max(max, diff = Math.abs(n - m))
    console.log n, m, max
    m = n

  max

require('./genericTester') [
  [[[2, 4, 1, 0]], 3]
], arrayMaximalAdjacentDifference
