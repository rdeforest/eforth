
# We "prime" the pump (pun intended) with all the primes in the first word so
# so don't have to test for primes being < 64 in maskOffCompounds


sieve = [0x325A65B7]
sieveEnd = sieve.length * 64 + 1
latestPrime = 61
primesFound = 17


numToAddr = (n) ->
  n = n / 2 - 1
  [n >>> 5, 1 << (n & 31)]

dammit = (wat = 'just because') -> throw new Error wat

nextPrime = (after = latestPrime, autoGen = true) ->
  # I hate special cases, but...

  return 3 if after is 2

  [wordIdx, mask] = numToAddr after + 1

  loop
    if (word = sieve[wordIdx]) is undefined or after > latestPrime
      if autoGen
        extendSieve latestPrime * 3
      else
        return -1
    else if word is 0
      wordIdx++
      after <<= 6
    else
      break

    if wordIdx > 2
      dammit 'skippy'

  loop
    console.log [wordIdx, mask.bin(), (word & mask).bin()].join ' '

    after += 2

    if word & mask
      break

    if not mask <<= 1
      extendSieve latestPrime << 1
      mask = 1
      word = sieve[wordIdx++]

  if latestPrime < after
    latestPrime = after

  after


maskOffCompounds = (n, from) ->
  if from and from > n
    m = from - (from % n)
  else
    m = n

  [word, mask] = numToAddr m

  wordShift = n >>> 6
  maskShift = (n & 63) >> 1

  while m < sieveEnd
    if m < 2
      dammit "death mask"

    m += n
    word += wordShift
    mask  = (mask <<       maskShift  & 32) |
            (mask >> (32 - maskShift) & 32) |

    console.log "#{word} #{mask.bin()} #{(~mask).bin()}"
    sieve[word] &= ~mask


extendSieve = (n) ->
  [wordIdx, mask] = numToAddr n

  if n > sieveEnd
    console.log "extending to reach #{n} at word #{wordIdx}"

    if n > 128
      dammit 'extensive'

    wordsToAdd = (wordIdx - sieve.length) * 2
    # XXX: .fill might be slow? Needs testing.
    [start, end] = [sieve.length, sieve.length + wordsToAdd]
    sieve.fill 0xFFFFFFFFF, start, end

    console.log sieve

    primeGen = knownPrimes 3

    while not ({value} = primeGen.next()).done
      console.log "masking #{value}"
      maskOffCompounds value, start

  [wordIdx, mask]


primes = (start, autoGen = true) ->
  if start
    p = nextPrime start, autoGen
  else
    p = 2

  loop
    yield p

    p = nextPrime p, autoGen

    if p < 2
      return p

knownPrimes = (start) -> primes start, false

isPrime = (n) ->
  [wordIdx, mask] = extendSieve n

  return sieve[wordIdx] & mask

Number.prototype.bin = -> @toString 2

module.exports = {sieve, extendSieve, numToAddr, isPrime, primes, knownPrimes, nextPrime}

