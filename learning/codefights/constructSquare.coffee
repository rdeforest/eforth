Object.values or= (o) -> v for k, v of o

module.exports.countLetters = countLetters = (s) ->
  letters = {}

  for c in s
    letters[c] or= 0
    letters[c]++

  Object
    .values letters
    .sort (a, b) -> a - b

module.exports = constructSquare = (originalPattern) ->
  startedAt = Date.now()
  pattern = countLetters originalPattern
  n = 0
  largest = -1

  loop
    if Date.now() - startedAt > 4000
      throw new Error 'timed out'

    n++

    if (len = (square = n * n).toString().length) > originalPattern.length
      return largest

    if len < originalPattern.length
      continue

    if matches pattern, square
      largest = square

module.exports.matches = matches = (counts, number) ->
  for count, idx in countLetters number.toString()
    if counts[idx] isnt count
      return false

  true
