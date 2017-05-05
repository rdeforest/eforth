zero = '0'.charCodeAt 0

isLucky = (n) ->
  n = n.toString().split('').map (c) -> c.charCodeAt(0) - zero
  t = 0

  while n.length
    [front, n..., back] = n
    #console.log t, front, back,
    t = t + front - back

  return t is 0

module.exports = isLucky

tester = require './genericTester'

tests = [
  [[1230], true]
  [[239017], false]
]

tester tests, module.exports
