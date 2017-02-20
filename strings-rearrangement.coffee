# Given an array of equal-length strings, check if it is possible to rearrange
# the strings in such a way that after the rearrangement the strings at
# consecutive positions would differ by exactly one character.

stringsRearrangement = (inputArray) ->
  return not not findArrangement inputArray

findArrangements = (inputArray) ->
  if inputArray.length < 2
    return [inputArray]

  if inputArray.length is 2
    return (
        if (diff inputArray...) is 1
          [inputArray]
        else
          undefined
      )

  [head, tail...] = inputArray

  arrangements = []
  
  if sortedTails = findArrangements tail
    if diff s, head is 1
      arrangements.push [s, sortedTail...]

    for s, i of sortedTail[0..-2]
      if (diff s, head is 1) and (diff sortedTail[i+1], head is 1)
        arrangements.push [sortedTail...].splice i, 0, s

  if diff s, head is 1
    arrangements.push [sortedTail..., s]

  return arrangements

