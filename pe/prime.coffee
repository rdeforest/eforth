lastUpdate = 0
statusUpdate = (msg...) ->
  if Date.now() - lastUpdate > 1000
    console.log msg...
    lastUpdate = Date.now()

class Primes
  constructor: ->
    @known = []
    @sieve = []
    @primeIdx = {}
    @discoverPrime 3


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
