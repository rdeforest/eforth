show = (cuts, ints) ->
  parts = []

  for int, idx in ints
    parts.push int
    parts.push '|' if idx in cuts

  parts.join " "

module.exports =
  threeSplit = (a) ->
    count = 0

    sumAll  = a.reduce (a, b) -> a + b
    sumLeft = 0

    for firstCut in [0..a.length - 3]
      sumLeft += a[firstCut]

      sumMiddle = 0
      sumRight = sumAll - sumLeft

      for secondCut in [firstCut + 1 .. a.length - 2]
        sumMiddle += n = a[secondCut]
        sumRight  -= n

        count++ if counted = (sumLeft is sumMiddle is sumRight)

        #console.log (show [firstCut, secondCut], a), "::", sumLeft, sumMiddle, sumRight

    count
