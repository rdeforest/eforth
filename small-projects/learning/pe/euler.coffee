Prime = require './prime'

class Euler
  constructor: ->

  intDiv: (n, d) ->
    count = 0

    while n >= d
      n -= d
      count++

    [count, n]

  factorsOf: (n) ->
    pGen = Prime.generator()
    factors = []

    while n > 1
      [p, more] = pGen.next()

      while p < n
        if not n % p
          n /= p
          factors.push p

    factors

  divisorsOf: (n) ->
    divisors = [1]
    dividends = [n]
    div = 1

    while n > div++
      [mul, mod] = @intDiv n, div

      if not mod
        divisors.push div

    divisors

module.exports = new Euler
