# Usage:
#
#   require('number')(Number)

module.exports = (Number) ->
  R = require 'ramda'

  primes = [2, 3, 5, 7]

  Number::divides = (n) -> 0 is (n % @)

  divides = (numerator) -> (denominator) -> denominator.divides numerator

  primeGen = (fromLargest) ->
    for p in primes
      yield p unless fromLargest

    q = p

    loop
      q += 2

      unless primes[1..].find divides q
        primes.push q
        yield q

  Number::isPrime = ->
    return undefined if @ < 2

    for p from primeGen(true) when p > @
      break

    @valueOf() in primes

  factorsOf = R.memoize (n, uniq) ->
    factors = []

    for p from primeGen()
      break if p > n

      while p.divides n
        factors.push p
        n /= p

        if uniq
          n /= p while p.divides n

    factors

  Number::factors = (uniq) -> factorsOf @valueOf(), uniq

#console.log 271.factors()

  _divisorsOf = R.memoize (n) ->
    return [] if n is 1

    R.uniq R.sort ((a, b) -> a - b),
      R.flatten ([n, _divisorsOf(n/p)...] for p in n.factors())

  divisorsOf = _divisorsOf # (n) -> [1, _divisorsOf(n)...]

  Number::divisors = -> divisorsOf @valueOf()

#console.log (2*3*4*5).divisors()


