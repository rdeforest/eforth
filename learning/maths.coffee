gcd = (a, b) -> if b is 0 then a else gcd b, a % b

# base^exp % mod
expmod = (base, exp, mod) ->
  if not exp then return 1

  n = base

  while exp
    n = (n * (
      if exp & 2
        exp -= 1
        base
      else
        exp >>= 1
        n
    )) % mod

primes = [2, 3]
factors = {}

primeIterator = ->
  idx = 0
  yield primes[idx++] while idx < primes.length

divmod = (n, p) ->
  #r = n % p
  #return [(n - r) / p, r] # should replace with efficient algo in future

  if n < p then return [0, n]

  d = p
  d <<= 1 while n > d
  q = 0

  while d >= p
    if d <= n
      n -= d
      q = (q << 1) + 1
    else if d > 1
      q = (q << 1)

    d >>= 1

  [q, n]

maxPrime = -> primes[-1..][0]

# sieve out undiscovered primes up to n
genPrimesTo = (n) ->
  multiples = primes.map (p) ->
    [q, r] = divmod maxPrime(), p
    q++
    [p * q, p, q]

  sieved = maxPrime()

  abort = 10000

  loop
    #throw 'looping' if abort-- < 1

    [pq, p, q] = multiples.shift()

    for x in [sieved + 2 .. pq - 1] by 2 when not factors[x]
      primes.push sieved = x

    pq += p
    q++
    if not factors[pq]
      #console.log 'factors:',
      factors[pq] = [p, q]

    idx = 0

    idx++ while multiples[idx] and pq > multiples[idx][0]

    if idx < 1 and pq >= n
      return sieved

    multiples.splice idx, 0, [pq, p, q]

factor = (n) ->
  genPrimesTo n

  if known = factors[n]
    (while known
      [p, n] = known
      known = factors[n]
      p
    ).concat n
  else
    []

module.exports = { maxPrime, genPrimesTo, factor, divmod, expmod, gcd, primes, factors, primeIterator }

insertSorted = (cmp, l, e) ->
  insert = (l, e) ->
    cursor = l.length - 1
    step = cursor >> 1

    loop
      diff = cmp e, l[cursor]

      switch
        when diff > 0 then cursor -= step
        when diff < 0 then cursor += step
        else return cursor

      if 0 is step >>= 1
        return cursor

  if arguments.length is 3
    insert l, e
  else
    insert


