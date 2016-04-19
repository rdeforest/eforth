#  2  3  5
#  7 11 13 17
# 19 23 29 31 37 41 43
# 47 53 59 61 67 71 73 79 83 89 97 . .

last = (l) -> l[l.length - 1]

singleton = null

class PrimeIndex
  constructor: (@row, @col, @nth) ->
    @primes = (new Prime).primes

  inc: ->
    if ++@col is @primes[row].length
      [@row, @col] = [@row + 1, 0]

      if @row is @primes.length
        @primes.makeMoar()

    return [row, col, nth++]

# @offset is 'index' of  the first bit
# @length is in bits
class Sieve
  constructor: (@offset = 3, knownPrimes, @length = 2**10) ->
    @length = @_idxToInternal @length

    # Round length up to word boundary
    if extra = @length & 7
      @length += 32 - extra

    @_resize @length >> 5

    if knownPrimes
      @removeMultiples n for n in knownPrimes

  _idxToInternal: (n) -> (n - @offset) >> 1
  _internalToIdx: (n) -> (n << 1)  + @offset

  removeMultiples: (n) ->
    n = _idxToInternal n

  _maskOn:  [0..31].map (n) ->    1 << n
  _maskOff: [0..31].map (n) -> ~ (1 << n)

  _resize: (wordCount) ->
    [oldWords, @words] = [@words, new Int32Array wordCount]

    @words.set oldWords.slice 0 if oldWords

  bitToWord: (n, resize) ->
    idx = (n - @offset) >> 5

    if idx < 0
      throw new RangeError "Index #{n} cannot be less than zero."

    if resize and idx > @words.length
      @_resize idx

  get:      (n) -> @words[@bitToWord n, false] &  @_maskOn[n]
  setTrue:  (n) -> @words[@bitToWord n, true ] |= @_maskOn[n]
  setFalse: (n) -> @words[@bitToWord n, true ] &= @_maskOff[n]

  _bitSearchMasks: [4..0].map (width) -> [1 << width, (~0) >> width]
  _lowestTrueBit: (word) ->
    bitIdx = 0

    for [width, mask] in @_bitSearchMasks
      if not word & mask
        word >>= width
        bitIdx += width
      else
        return bitIdx

    return -1

  nextTrue: (from) ->
    wordIdx = @bitToWord from

    loop
      word = @words[wordIdx]

      if (bitIdx = @_lowestTrueBit word) isnt -1
        return @offset + @wordIdx << 5 + @bitIdx

      if ++wordIdx is @words.length
        return -1

  makeIterator: ->
    n = 0

    return next: ->

    loop
      another = @nextTrue n
      if another is -1


class Prime
  constructor: ->
    if singleton
      return singleton

    singleton = this

    @_gen = @generator(@top)
    @primes = [@lastRow = [2]]
    @length = 1
    @rows = 1
    @sieve = (new Sieve 3, 100)

  rowWidth: (n) -> Math.ceil(n / Math.log n)

  addPrime: (p) ->
    @top = p
    @sieve = q for q in @sieve when

    @length++

    if @rowWidth @lastRow[0] > @lastRow.length
      @lastRow.push p
    else
      @rows = @primes.push @lastRow = [p]

    return [@rows, @lastRow.length, @length]

  isPrime: (n) -> -1 isnt @primeIndex n

  primeIndex: (p) ->
    if p > @top
      @factor p

      return @topIdx

    rowIdx = 0
    lastRow = @topIdx[1]
    idx = 0

    while row = @primes[rowIdx++]
      if p < last row
        col = row.indexOf p

        if col is -1
          return -1

        [row, col, idx + col]
      else if rowIdx is lastRow

  incPidx: ([row, col, nth]) ->
  pidxGet: ([row, col]) -> @primes[row][col]

  nthPrime: (n) ->
    rowIdx = 0

    while n > @primes[row]
      row = @primes[rowIdx]

      if rowIdx++ < @primes.length - 1
        n -= row.length
      else
        while rowIdx >= @primes.length - 1
          @makeMoar()

    @primes[row][n]

  factor: (n) ->
    [x, y] = [0, 0]
    factors = []

    while n > 1
      if pidx[0] >= @primes.length
        @addPrime n

    # XXX: not done

  makeMoar: ->
    candidate = @top + 2
    factors = @factor candidate

  genPrimes: (opts) ->
    {past, count} = opts

    if 'number' is typeof past
      @factor past

      while @top < past
        @makeMoar()

    if 'number' is typeof count
      while count-- > 0
        @makeMoar()

  primeAfter: (n) ->
    @genPrimes past: n

  generator: (from = 2) ->
    loop
      yield from = @primeAfter from

known = 10: [2, 3]
sieve = [4, 9]

getOrder = (n) ->
  order = 10

  while order < p
    order *= 10

  order

notePrime = (p) ->
  order = getOrder p

  known[order] or= {}
  known[order].push p

isPrime = (p) ->
  order = getOrder p

  if candidates = known[order]
    if p < candidates[candidates.length - 1]
      return p in candidates

  isPrimeTHW p

isPrimeTHW = (p) ->


module.exports =
  primeGenerator: primeGenerator

  isPrime: (n) ->


    @makeMore Number n
    (@primeIdx[n] and true or false) or n is 2 or n is 3


  makeMore: (to = Number @max * 2 + 1) ->
    while @max < to
      @findNext()
      statusUpdate @max, @known.length
    return undefined

  newMakeMore: (to = Number @max * 2 + 1) ->
    while @max < to
      statusUpdate @max, @known.length, pidx
      next = Number @max + 2
      pidx = 0

      while pidx < @known.length
        while next > @sieve[pidx]
          @sieve[pidx] += @known[pidx] * 2

        if next is @sieve[pidx]
          next += 2
          pidx = 0
          continue

        pidx++

      @discoverPrime next

  bubble: (pidx = 0) ->
    @sieve[pidx] += @known[pidx] * 2
    qidx = pidx + 1

    while qidx < @known.length
      if @sieve[pidx] is @sieve[qidx]
        @sieve[qidx] += @known[qidx] * 2
        pidx = qidx
      qidx++

    undefined

  findNext: ->
    next = Number @max + 2
    pidx = 0

    while pidx < @known.length
      while next > @sieve[pidx]
        @bubble pidx

      if next is @sieve[pidx]
        next += 2
        pidx = 0
        continue

      pidx++

    @discoverPrime next
    return next

  oldFindNext: ->
    next = Number @max + 2

    loop
      done = true

      for pidx in [0 .. @known.length - 1]
        [p, m] = [@known[pidx], @sieve[pidx]]

        while (diff = next - m) > 0
          m = @sieve[pidx] += p

        if diff is 0
          next += 2
          done = false
          break

      if done
        @discoverPrime next
        return next


  discoverPrime: (p) ->
    @primeIdx[p] = @known.length
    @known.push p
    @sieve.push p * 3
    @max = p


  generator: ->
    idx = 0

    loop
      if idx > @known.length
        setTimeout => @makeMore()

      if idx is @known.length
        @makeMore()

      yield @known[idx++]


module.exports = new Primes

