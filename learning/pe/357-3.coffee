R = require 'ramda'

primes = [2, 3, 5, 7]

Number::divides = (n) -> 0 is (n % @)

divides = (n) -> (m) -> m.divides n

primeGen = (fromLargest) ->
  for p in primes
    yield p unless fromLargest

  # Every third odd number after 3 is divisible by 3, so skip it.
  addMore = 4 - (p - primes[-2..][0])

  q = p

  loop
    q      += 2 + addMore
    addMore = 2 - addMore

    unless primes[1..].find divides q
      primes.push q
      yield q

Number::isPrime = ->
  return undefined if @ < 2

  break for p from primeGen(true) when q <= p

  q in primes

factorsOf = R.memoize (n, uniq) ->
  factors = []

  for p from primeGen()
    break if p > n

    while p.divides n
      console.log "#{p} divides #{n}?"
      factors.push p
      n /= p

      if uniq
        n /= p while p.divides n

    console.log "#{p} doesn't divide #{n}"

  console.log "Last p: #{p}"
  factors

Number::factors = -> factorsOf @valueOf()

console.log ((2*3*5)**3).factors()

_divisorsOf = R.memoize (n) ->
  divisors = []

  while n > 1
    for p in factorsOf n, true

divisorsOf = (n) -> _divisorsOf(n).concat 1, n

Number::divisors = -> divisorsOf @valueOf()

#console.log ((2*3*4*5)**3).divisors()

isGenerator = R.memoize (n) ->
  halfN = n >> 1

  for d from n.divisors()
    if d > halfN or not (d + (n/d)).isPrime()
      return false

  true

#for n in [10..40]
#  console.log n if isGenerator n

###
