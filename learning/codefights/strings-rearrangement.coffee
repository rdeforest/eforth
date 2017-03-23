# Given an array of equal-length strings, check if it is possible to rearrange
# the strings in such a way that after the rearrangement the strings at
# consecutive positions would differ by exactly one character.

Array.prototype.without = (idx) ->
  switch idx
    when 0            then @[1..]
    when @length - 1  then @[..-2]
    else (ll = @slice()).splice(idx, 1); ll

offByOne = (a, b) ->
  count = 0

  for l, i in a.split ''
    count++ if b[i] isnt l
    return false if count > 1

  return count is 1

hasSolution = (remaining, soFar = []) ->
  if not remaining.length
    return true

  if not soFar.length
    for s, i in remaining
      if solution = hasSolution remaining.without(i), soFar.concat [s]
        return solution
  else
    [firstWord, rest..., lastWord] = soFar
    (lastWord = firstWord) if soFar.length is 1

    for s, i in remaining
      if offByOne s, lastWord
        if solution = hasSolution remaining.without(i), soFar.concat [s]
          return solution

      if offByOne s, firstWord
        if solution = hasSolution remaining.without(i), [s].concat soFar
          return solution

  return false

stringsRearrangement = (inputArray) ->
  not not hasSolution inputArray

require('./test-sa') stringsRearrangement

module.exports = {hasSolution, offByOne}

