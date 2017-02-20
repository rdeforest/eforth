# Given an array of equal-length strings, check if it is possible to rearrange
# the strings in such a way that after the rearrangement the strings at
# consecutive positions would differ by exactly one character.

concat = (a, b) -> a.concat b

unique = (a, b) -> if a[0] is b then a else [b, a...]

diff0 = (a, b) -> a.length is 0 or a[0] is b[0] and diff0 a[1..], b[1..]

diff1 = (a, b) ->
  undefined in [a, b] or not a.length or
    (if a[0] is b[0] then diff1 else diff0) a[1..], b[1..]

threadAndNeedle = (word, idx, words) ->
  words = [words...]
  [ words.splice(idx, 1), words]

threadings = ([word, words]) ->
  arrangements words
    .filter ([first, rest...]) -> diff1 word, first
    .map ([words]) -> [word, words...]

arrangements = (words) ->
  return [words] if words.length is 1

  words
    .map    threadAndNeedle
    .map    threadings
    .reduce concat, []


stringsRearrangement = (inputArray) ->
  arrangements inputArray
    .length > 0


module.exports = {
  concat, unique
  arrangements, threadings, threadAndNeedle
  diff0, diff1
  stringsRearrangement
}

