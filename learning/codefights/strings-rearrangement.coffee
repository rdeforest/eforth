# Given an array of equal-length strings, check if it is possible to rearrange
# the strings in such a way that after the rearrangement the strings at
# consecutive positions would differ by exactly one character.

offByOne = (a, b) ->
  unless a and b
    console.log "falsy things match everything", a, b
    return true

  count = 0

  for l, i in a.split ''
    count++ if b[i] isnt l

  console.log "#{a} and #{b} have #{count} differences"

  return count is 1

solutions = (word, words...) ->
  console.log "sol: #{word}", words

  if not words.length
    return [[word]]

  succeeded = []
  failed = []

  sol = solutions words

  for path in sol.succeeded
    for position in [0..path.length]
      if offByOne(word, path[position - 1]) and offByOne(word, path[position])
        console.log "Extending [#{path.join ", "}] by inserting #{word} at #{position}"
        extended = Array.from path
        extended.splice position, 0, word
        succeeded.push extended
      else
        failed.push {path, word}

  for failure in sol.failed
    for 

  {succeeded, failed}

stringsRearrangement = (inputArray) ->
  console.log found = solutions inputArray...
  found.succeeded.length > 0

(require './genericTester') [
  [ [[ "aa",  "ab",  "bb"]], true]
  [ [[ "ab",  "bb",  "aa"]], true]
  [ [["aba", "bbb", "bab"]], false]
  [ [[  "q",   "q"       ]], false]
], stringsRearrangement

module.exports =
  { stringsRearrangement, solutions }
