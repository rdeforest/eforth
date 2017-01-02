primes = [2, 3]

lastPrime = 3

knownFactor = (n) ->
  primes.find (p) ->
    n > p and not n % p

netPrime = ->
  lastPrime += 2 while 
