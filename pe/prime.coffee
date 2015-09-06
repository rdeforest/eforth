class Primes
  constructor: ->
    @known = []
    @sieve = []
    @primeIdx = {}
    @discoverPrime p for p in [2, 3]


  isPrime: (n) ->
    @makeMore n
    n is 2 or (@primeIdx[n] and true or false)


  makeMore: (to = @max * 2 + 1) ->
    while @max < to
      @findNext()


  findNext: ->
    next = @max + 2
    done = true

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
    @sieve.push p << 1
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

