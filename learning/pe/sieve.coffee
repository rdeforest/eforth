WORD_SIZE = 32

div = (n, d) -> [Math.floor(n / d), n % d]

rot = (num, bits) -> (num >> bits) & (num << (WORD_SIZE - bits)

lowestOneBit = (require './lowest-one') {WORD_SIZE}

class Sieve
  constructor: ->
    @offset = 3
    @primes = [2]
    @sieve = new UInt32Array 1
    @sieve.fill 0x55555555
    @gcd = 2


  # Assumes current prime was masked off already
  nextOffset: ->
    word = 0

    loop
      if @sieve[word++]
        break

    @offset + (word * WORD_SIZE) + lowestOneBit @seive[word]


  iterate: ->
    @primes.push @next
    @gcd *= @next
    @maskAndShift()


  maskAndShift: ->
    mask = 1
    [skip, shift] = div p, WORD_SIZE

    if not skip
      for repeat in [2 .. ]
