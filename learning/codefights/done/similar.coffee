same = (a, b) ->
  for n, i in a when b[i] isnt n
    return false

  return true

swap = (l, from, to) ->
  ll = l.splice()
  [ll[from], ll[to]] = [l[to], l[from]]
  ll

areSimilar = (a, b) ->
  diffs = []

  for n, i in a when b[i] isnt n
    diffs.push [n, b[i]]

    if diffs.length > 2
      return false

  #console.log diffs

  if diffs.length is 0
    return true

  return diffs.length is 2 and diffs[0][0] is diffs[1][1] and diffs[1][0] is diffs[0][1]

module.exports = areSimilar

tester = require './genericTester'

tests = [
  [[[1..3], [1..3]], true]
  [[[1..3], [2, 1, 3]], true]
  [[[1,2,2], [2,1,1]], false]
]

tester tests, module.exports

