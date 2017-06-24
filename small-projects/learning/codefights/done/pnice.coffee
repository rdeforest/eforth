###

For the given positive integer n and prime number p, the positive integer i is
called p-nice if the value of n choose i is divisible by p.

Note: n choose i is the number of ways to choose unordered i distinct item(s)
from n distinct item(s) with 0 ≤ i ≤ n.

Given n and p, calculate the number of p-nice numbers that are less than n.

###

memoize = (fn) ->
  name = fn.name || Symbol()

  (args...) ->
    k = JSON.stringify args
    return (memoize[name] ||= {})[k] ||= fn args...

knownPrimes = [2,3]
primes = ->
  n = 0
  yield n for n in knownPrimes
  loop
    n += 2
    prime = true
    
    for p in knownPrimes
      if 0 is n % p
        prime = false
        break

    if prime
      knownPrimes.push n
      yield n

factors = memoize (n) ->
  f = []
  nn=n
  
  for p from primes()
    loop
      break if n % p
      if p > n
        throw new Error "bug: #{nn} #{n} #{p} #{f}"
      n /= p
      f.push p

    if n is 1 then return f

factorial = memoize (n) ->
  if n < 2
    n
  else
    n * factorial n - 1

#nChooseK = memoize (n, k) -> factorial(n)/(factorial(k) * factorial(n - k))
nChooseK = memoize (n, k) ->
  return 1 if k is 0 or k is n

  #return nChooseK(n - 1, k - 1) + nChooseK(n - 1, k)
  n1 = n + 1
  times = []
  div = []

  for i in [1..k]
    times.push factors(n1 - i)...
    div.push factors(i)...

  ret = 1
  times =
    for x in times
      if -1 < idx = div.indexOf x
        div.splice idx, 1
        continue
      else
        x

  #console.log times
  times.reduce (a, b) -> a * b

logB = (n, b) -> Math.log(n) / Math.log(b)

isPNice = (n, p, k) ->

  return 0 is nChooseK(n, k) % p
  pow = logB n, p
  pow is Math.floor pow

pNiceNumbers = (n, p) ->
  nice = (i for i in [1..n - 1] when isPNice n, p, i)
  #console.log nice
  return nice.length

gcd = (n, k) ->
  if k < 1 then return n
  gcd(k, n % k)

Object.assign global, {memoize, factorial, nChooseK, isPNice, pNiceNumbers, logB, primes, factors, gcd}
