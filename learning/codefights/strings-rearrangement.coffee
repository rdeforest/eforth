# Given an array of equal-length strings, check if it is possible to rearrange
# the strings in such a way that after the rearrangement the strings at
# consecutive positions would differ by exactly one character.

minLevel = 3

debug = (level, args...) -> console.log args... if level >= minLevel

Array::last = -> @[@length - 1]

offByOne = (a, b) ->
  unless a and b
    debug 0, "falsy things match everything", a, b
    return true

  count = 0

  for l, i in a.split ''
    count++ if b[i] isnt l

  debug 0, "#{a} and #{b} have #{count} differences"

  return count is 1

solutions = (word, words...) ->
  debug 0, "sol: #{word}", words

  failed = []

  if not words.length
    return {succeeded: [[word]], failed}

  {succeeded, failed} = solutions words...

  stillFailing = []

  for path in succeeded
    for attempting in [word, failed...]
      fail = true

      if offByOne word, path[0]
        succeeded.push [attempting, path...]
        fail = false

      if offByOne word, path.last()
        succeeded.push [path..., attempting]
        fail = false

      if fail
        stillFailing.push attempting

  {succeeded, failed: stillFailing}

stringsRearrangement = (inputArray) ->
  debug 3, "found", found = solutions inputArray...
  found
    .succeeded
    .filter (s) -> s.length is inputArray.length
    .length > 0

(require './genericTester') [
  [ [[ "aa",  "ab",  "bb"]], true]
  [ [[ "ab",  "bb",  "aa"]], true]
  [ [["aba", "bbb", "bab"]], false]
  [ [[  "q",   "q"       ]], false]
], stringsRearrangement

module.exports =
  { stringsRearrangement, solutions }
