###

    Consider the divisors of 30: 1,2,3,5,6,10,15,30.  It can
    be seen that for every divisor d of 30, d + 30/d is prime.

    Find the sum of all positive integers n not exceeding
    100 000 000 such that for every divisor d of n, d+n/d is
    prime.

###

Primes = require './prime'
Euler = require './euler'

class p357
  constructor: ->

  answer: (max, debug = -> ) ->
    sum = 1 # 1 is ok() because 1 + 1/1 = 2, which is prime
    pGen = Primes.generator()
    loop
      p = pGen.next()[0]
      if Primes.isPrime p + 2
        candidate = p * 2

        if candidate > max
          break

        if @ok candidate, debug
          sum += candidate

    return sum

  ok: (n, debug) ->
    div = Euler.divisorsOf n

    return false if n % 2
    return false if div.length % 2
    
    while div.length
      a = div.shift()
      b = div.pop()
      s = a + b
      p = Primes.isPrime s

      if debug
        debug a, b, s, p

      return false unless p

    return true

module.exports = new p357
