module.exports =
  allLongestStrings = (strings) ->
    longest = [s = strings.shift()]
    bestSoFar = s.length

    for s in strings
      switch
        when bestSoFar is sLen = s.length
          longest.push s

        when bestSoFar < sLen
          longest = [s]
          bestSoFar = sLen

    longest
