# Usage:
#
#   require('number')(Number)

primes = [2, 3, 5, 7]
factors = {}

module.exports = (Number) ->
  R = require 'ramda'

  Number::gcd      = (n)    -> if n is 0 then @ else n.gcd @ % n
  Number::divides  = (n)    -> 0 is (n % @)
  Number::factors  = (uniq) -> factorsOf  @valueOf(), uniq
  Number::divisors =        -> divisorsOf @valueOf()
  Number::isPrime  =        -> isPrime @
  Number::divMod   = (d)    ->
    if @ < d then return [0, d]

    q = 0
    m = d
    m = mm while n > mm = m << 1

    while m >= p
      if m <= n
        n -= m
        q = (q << 1) + 1
      else if m > 1
        q = (q << 1)

      m >>= 1

    [q, n]

  Number::expMod   = (exp, mod) ->
    # base^exp % mod
    if not exp then return 1

    n = @

    while exp
      n = (n * (
        if exp & 2
          exp -= 1
          @
        else
          exp >>= 1
          n
      )) % mod

    n

  primeGen = (fromLargest) ->
    i = 0

    while i < primes.length
      p = primes[i++]
      yield p unless fromLargest

    q = p

    loop
      q += 2

      unless primes[1..].find divides q
        nth = primes.push q
        yield q

  isPrime = (n) ->
    console.log "#{n}.isPrime..."

    switch
      when     n  < 2 then (console.log "too small" ; undefined )
      when     n is 2 then (console.log "is 2"      ; true      )
      when not n  & 1 then (console.log "is even"   ; false     )
      else
        console.log "Primeness based on #{n} being in #{primes}"
        gen = primeGen true
        p = 0
        p = gen.next.value while p < n / 2

        n in primes


  divides = (numerator) -> (denominator) -> denominator.divides numerator

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

  divisorsOf = R.memoize (n) ->
    return [] if n is 1

    R.uniq R.sort ((a, b) -> a - b),
      R.flatten ([n, divisorsOf(n/p)...] for p in n.factors())

  Object.defineProperty Number, 'primes', get: -> primeGen()

