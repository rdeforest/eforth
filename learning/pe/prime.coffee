_ = require 'underscore'
fs = require 'fs'
path = require 'fs'

#math = require 'math.js'
#math.config
#  number: 'BigNumber'
#  precision: 64

primes = [2, 3]

memoize = (name, fn) ->
  if not name
    throw new Error "name is required now"

  argsSeen = {}

  (args...) ->
    key = JSON.stringify args

    if (seen = argsSeen[key]) isnt undefined
      #console.log name, key, "remembered:", seen
      seen
    else
      #console.log name, key, "remembering:", seen = argsSeen[key] = fn args...
      argsSeen[key] = fn args...


_factor = memoize 'factor', (n, nextPrimeTest = 0) ->
  found = []
  pidx = 0

  loop
    p = primes[pidx]

    if p >= n
      return [found..., n]

    if 0 is n % p
      found.push p
      n /= p

    else
      ++pidx

      if pidx is primes.length
        if nextPrimeTest
          primes.push n
          return [n]

        # Need another prime...
        p += 2

        #console.log p, nextPrimeTest

        while (_factor p, nextPrimeTest + 1).length > 1
          p += 2

_permuteProducts = memoize 'permuteProducts', (factors) ->
  if factors.length < 2
    return factors

  [first, rest...] = factors

  permuted = _permuteProducts rest

  _.union [first], permuted, permuted.map (n) -> n * first


_divisors = memoize 'divisors', (n) ->
  factors = _factor n
  _.union [1], factors, _permuteProducts factors


module.exports = pr =
  load: (targetPath = "./knownPrimes.json") ->
    data = ""

    new Promise (resolve, reject) ->
      fs.createReadStream targetPath
        .setEncoding 'utf-8'
        .on 'data', (d) -> data = data + d
        .on 'end', ->
          resolve module.exports.primes = primes =
            JSON.parse data
        .on 'error', (e...) -> reject e...

  save: (targetPath = "./knownPrimes.json") ->
    out = fs.createWriteStream targetPath + ".new"
    out.write JSON.stringify primes
    return

  primes: primes

  primeGen: (startAfter = 1) ->
    pIdx = _.sortedIndex primes, startAfter
    if primes[pIdx] is startAfter
      pIdx++

    loop
      if pIdx is primes.length
        p = primes[pIdx - 1] + 2

        while (_factor p, 1).length > 1
          p += 2

      yield primes[pIdx++]

  factor: (n) ->
    if 'number' isnt typeof n or n is NaN or n < 1
      throw new Error "Cannot factor #{JSON.stringify n}"

    n = Math.floor n

    if pr.isPrime n
      return [n]

    _factor n


  isPrime: (n) ->
    if n > primes[primes.length - 1]
      (_factor n).length is 1
    else
      idx = _.sortedIndex primes, n
      primes[idx] is n

  divisors: _divisors

  pp: _permuteProducts
