STARTGEN = 6
HOWMANY  = 10000
MAXGEN   = STARTGEN + HOWMANY

process = require 'process'

R = require 'ramda'

primes = [2, 3, 5, 7]

Number::divides = (n) -> 0 is (n % @)

divides = (n) -> (m) -> m.divides n

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

knownGenerators = []
knownNonGenerators = []

hasDupe = (sortedList) ->
  -1 < sortedList.findIndex (e, i, l) -> l[i+1] is e

isGenerator = (n, verbose) ->
  # return false if n in knownNonGenerators

  # 1 + prime/1 = prime + 1
  # which is divisible by 2
  return false if n.isPrime()

  # n + n*n*p*q/n = n + n*p*q = n*(q*p+1)
  # which is divisible by n (and also 2, but that's less obvious)
  return false if hasDupe factors = n.factors()

  for f in factors
    return false if (n - f) in knownGenerators

  halfN = n >> 1

  for d in n.divisors()
    unless (divided = d + (n / d)).isPrime()
      return false

    break if d >= halfN

    #console.log "#{d} + #{n}/#{d} = #{divided}" if verbose

  knownGenerators.push n

  # let g be a found generator
  # let p and q be factors of g
  # g + p cannot be a generator because it is p * (q + 1)
  # q + 1 is even because q is prime
  #
  # for p in factors[1..]
  #   q = n + p

  #   while q < MAXGEN
  #     knownNonGenerators[q] = true
  #     q += p

  true

Array::cmp = (other) ->
  if  @length and other.length
     (@[0]     -  other[0]) or
      @[1..] .cmp other[1..]
  else
      @length  -  other.length

total       =
count       =
lastUpdate  =
mostFactors = 0

n = STARTGEN - 4
n++ until isGenerator n

while n < MAXGEN
  if isGenerator n, false
    count++
    total += n

    if mostFactors < (f = n.factors()).length
      mostFactors = f.length

    if (Date.now() - lastUpdate) > 1000
      console.log n, mostFactors, count, total, f
      lastUpdate = Date.now()

  n += 4

console.log count, total
