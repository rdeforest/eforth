concat = (a, b) -> a.concat b

module.exports =
  stringsCrossover = (inputStrings, result) ->
    pairs = inputStrings[0..-2]
      .map (s, i) ->
        inputStrings[i + 1..-1]
          .map (t) -> [s, t]
      .reduce concat

    for c, i in result
      pairs = pairs.filter (pair) ->
          #found =
          pair.find (s) -> s[i] is c
          #console.log pair, found
          #found
      
      break if pairs.length is 0

    pairs.length

#module.exports.tests =
#  [ [ [ "a", "b", "c", "d", "e" ], "c" ] ]
