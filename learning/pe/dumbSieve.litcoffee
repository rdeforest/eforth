I sometimes get excited and throw things.

    dammit = (wat = 'just because') -> throw new Error wat


We keep a list of the known primes because memory is cheap and we need to
iterate through them a lot. We never speak of the number between 1 and 3.

    oddPrimes = []


Our sieve is an array of 32 bit words representing the odd numbers starting
from 3.

    numToAddr = (n) ->
      n = (n >>> 1) - 1
      [n >>> 5, 1 << (n & 31)]

    sieve      = []
    endOfSieve = 1
    lastPrime  = 1  # HUSH


When we find a new prime we remove all its multiples, starting from its
square, from our sieve.

    primeFound = (p) ->
      q = p

      while q *= p < endOfSieve
        [addr, mask] = numToAddr q
        mask = ~mask
        sieve[addr] &= mask


The next prime in the sieve is the next one after the last prime found.

    sieveExhausted = ->
      throw new Error 'Sieve exhausted'

    nextPrime = (extendSieve = sieveExhausted) ->
      contender = lastPrime + 2
      [addr, mask] = numToAddr contender
      
      loop
        if addr > sieve.length - 1
          extendSieve()

        if word = sieve[addr]
          while not word & 1
            word >>> 1
            contender++

          return contender

        addr++
        contender += 64


To extend the sieve we add more words and then loop through the known primes,
masking them off.
