# Given an array of equal-length strings, check if it is possible to rearrange
# the strings in such a way that after the rearrangement the strings at
# consecutive positions would differ by exactly one character.

Array::flattenOnce = ->
  @reduce (
    (acc, e) ->
      if Array.isArray e
        acc.concat e
      else
        acc.push e
  ), []

Array::flatten = ->
  @reduce (
    (acc, e) ->
      if Array.isArray e
        acc.concat(e).flatten()
      else
        acc.push e
        acc
  ), []

Array::is = (other) ->
  switch
    when @length isnt other.length then false
    when not @length               then true
    else
      other.length is @length and @_is other

Array::_is = ([x, xs...]) ->
  not @length or x is @[0] and xs is @[1..]

offByOne = (a, b) ->
  unless a and b
    return true

  count = 0

  for l, i in a.split ''
    count++ if b[i] isnt l

  return count is 1

validInsert = (a, b, c) -> offByOne(a, b) and offByOne b, c

class SolutionInProgress
  constructor: (@inProgress = [], @unused = []) ->

  solved: -> @unused.length is 0

  # self, string, list of string -> list of progress
  makeProgress: (word, unused = []) ->
    progress =
      for right, i in @inProgress when validInsert @inProgress[i - 1], word, right
        [left, right] = [
          if i then @inProgress[..i - 1] else []
          @inProgress[i..]
        ]

        new SolutionInProgress(
          [left..., word, right...]
          unused
        )

    if not progress.length
      progress = [new SolutionInProgress @inProgress, [@unused..., word]]

    loop
      progress = progress.concat moreProgress
      moreProgress = (progress.map (sol) -> sol.retryUnused()).flatten()
      break unless moreProgress.length

    progress

  retryUnused: ->
    @unused
      .map (word, i) ->
        @makeProgress word, @unused[..i - 1].concat @unused[i + 1..]
      .flatten()

found = null

addWord = (progress, word) ->
  console.log "addWord",
    progress = progress
      .map (sol) -> sol.makeProgress word
  progress .flatten()

stringsRearrangement = (inputArray) ->
  found = [ new SolutionInProgress ]

  for word in inputArray
    found = addWord found, word

  return found.filter((sol) -> sol.solved()).length

Object.assign global,
  module.exports = { SolutionInProgress, stringsRearrangement, found, addWord }

if false
  (require './genericTester') [
    [ [[ "aa",  "ab",  "bb"]], true]
    [ [[ "ab",  "bb",  "aa"]], true]
    [ [["aba", "bbb", "bab"]], false]
    [ [[  "q",   "q"       ]], false]
  ], stringsRearrangement

