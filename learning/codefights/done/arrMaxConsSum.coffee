arrayMaxConsecutiveSum = (l, k) ->
  cons = l.splice 0, k
  curSum = cons.reduce (a, b) -> a + b

  Math.max curSum, (
    for x in l
      curSum = curSum - cons.shift() + x
      cons.push x
      curSum
    )...

(require './genericTester') [
  [ [[2,3,5,1,6], 2], 8 ]
], arrayMaxConsecutiveSum
