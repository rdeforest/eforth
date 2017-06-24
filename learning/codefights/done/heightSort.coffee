sortByHeight = (input) ->
  sorted = input
    .filter (n) -> n > -1
    .sort (a, b) -> a - b

  input.map (n) ->
    if n is -1
      -1
    else
      sorted.shift()

module.exports = sortByHeight

tester = require './genericTester'

tests = [
  [[[-1, 150, 190, 170, -1, -1, 160, 180]], [-1, 150, 160, 170, -1, -1, 180, 190]]
]

tester tests, module.exports

