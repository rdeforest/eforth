module.exports =
  alphanumericLess = (a, b) ->
    TOKEN_REGEXP = /^(?:(\d+)|(\D))(.*)/
    zeroWinner = false

    while a.length
      if match = a.match TOKEN_REGEXP
        [aMatched, aNumber, aChar, a] = match

        false and console.log {aMatched, aNumber, aChar, a}

        if not b.length
          return false

        [bMatched, bNumber, bChar, b] = b.match TOKEN_REGEXP

        false and console.log {bMatched, bNumber, bChar, b}

        if aChar
          return false unless bChar
          return false if aChar > bChar
          return true  if aChar < bChar
        else if bChar
          return true
        else
          [[aMatch, aZeros, aDigits], [bMatch, bZeros, bDigits]] =
            [aNumber, bNumber].map (a) -> a.match /^(0*)(.*)/

          if aDigits < bDigits
            return true
          else if aDigits is bDigits
            zeroWinner or= true if aZeros > bZeros
          else
            return false

    return b.length > 0 or zeroWinner

# Object.assign global, {
#   tokenize, alphanumericLess, isNumeric, numCompare,
#   compareTokenLists, leadingZeroCompare
#   compareTokens
#   zip
# }
