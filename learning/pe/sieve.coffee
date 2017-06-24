Decimal = require 'decimal.js'

WORD_SIZE = 32

div = (n, d) -> [Math.floor(n / d), n % d]

rot = (num, bits) -> (num >> bits) & (num << (WORD_SIZE - bits)

lowestOneBit = (require './lowest-one') {WORD_SIZE}

class Sieve
  constructor: ({@offset = 3, @scale = 2, bits = 1024, @defValue = false}) ->
    @defValue = not not @defValue

    @words = bits >> 5
    if bits % 32
      @words ++

    @sieve = new Uint32Array @words

  _map: (n) ->
    return

  _unmap: (idx) ->

  get: (n) ->
    idx = _map n

    word = @seive[idx.wIdx]

    if word and word & idx.maskOn
      return     @defValue
    else
      return not @defValue



  set: (n) ->
  clear: (n) ->
  toggle: (n) ->
    if @get n

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
