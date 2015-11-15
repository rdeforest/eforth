###
Consider the divisors of 30: 1,2,3,5,6,10,15,30.
It can be seen that for every divisor d of 30, d+30/d is prime.

Find the sum of all positive integers n not exceeding 100 000 000
such that for every divisor d of n, d+n/d is prime.
###

main = ->
  init()
  test()

init = ->
  noteNewPrimes [2, 3]

test = ->
  kp = knownPrimes true

  for x in [1..11]
    console.log kp.next()


maxKnownPrime = 1
primes = {}


noteNewPrimes = (pList) ->
  for p in pList
    rank *= RANK_FACTOR while rank < p
    primes[rank] or= []
    primes[rank].push p

  maxKnownPrime = p


knownPrimes = (gen) ->
  rank = RANK_FACTOR
  pIdx = 0
  needMorePrimes = false

  while not needMorePrimes
    if not primes[rank]
      console.log primes
      throw new Error "What happened to rank #{rank}? "
    p = primes[rank][pIdx++]

    if p is maxKnownPrime
      if gen
        getNextPrime()
      else
        needMorePrimes = true

    if not pIdx < primes[rank].length
      rank *= RANK_FACTOR
      pIdx = 0

    yield p

  yield return

getNextPrime = ->
  sieve = {}
  sieveTop = maxKnownPrime ** 2 + 1
  kp = knownPrimes()
  
  while not ({value, done} = kp.next()).done
    q = maxKnownPrime - (maxKnownPrime % value)

    while q < sieveTop
      q += value
      sieve[q] = true

  newPrimes = (p for p in [maxKnownPrime + 2 .. sieveTop] when not sieve[p])

  noteNewPrimes newPrimes

  return newPrimes[0]

main()
