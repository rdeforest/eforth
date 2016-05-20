_ = require 'underscore'
math = require 'math.js'
math.config
  number: 'BigNumber'
  precision: 64

memoize = (fn, name = 'unnamed') ->
  argsSeen = {}

  (args...) ->
    key = JSON.stringify args

    if (seen = argsSeen[key]) isnt undefined
      seen
    else
      argsSeen[key] = fn args...


_factor = memoize (n, nextPrimeTest = 0) ->
  found = []
  pidx = 0

  loop
    p = pr.primes[pidx]

    if p >= n
      return [found..., n]

    if 0 is n % p
      found.push p
      n /= p

    else
      ++pidx

      if pidx is pr.primes.length
        if nextPrimeTest
          pr.primes.push n
          return [n]

        # Need another prime...
        p += 2

        while (_factor p, nextPrimeTest + 1).length > 1
          p += 2

module.exports = pr =
  primes: [2, 3]

  factor: (n) ->
    if 'number' isnt typeof n
      throw new Error "Cannot factor #{JSON.stringify n}"

    n = Math.floor n

    if pr.isPrime n or n < 2
      return [n]

    _factor n


  isPrime: (n) ->
    if n > pr.primes[pr.primes.length - 1]
      (_factor n).length is 1
    else
      idx = _.sortedIndex pr.primes, n
      pr.primes[idx] is n
