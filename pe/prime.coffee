primes = [2, 3]
isPrime = {2: true, 3: true}

Object.defineProperty this, 'lastKnownPrime'
  get: -> primes[-1..][0]

makeMorePrimes = (to = lastKnownPrime ** 2) ->
  sieve = {}

  for pi in [0 .. primes.length - 1]
    p = primes[pi]

    for q in primes[pi .. primes.length - 1]
      pq = p*q
      sieve[pq] = true
      break if pq >= to

  for x in [lastKnownPrime + 2 .. to]
    if not sieve[x]
      primes.push x
      isPrime[x] = true

primeMakerMaker = ->
  idx = 0
  loop
    if idx > primes.length
      setTimeout makeMorePrimes
    yield primes[idx++]

module.exports =
  primeMakerMaker: primeMakerMaker
  isPrime: (x) -> isPrime[x]
