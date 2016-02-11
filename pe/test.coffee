Primes = require './prime'
Euler = require './euler'
p357 = require './357'

if true
  Primes.makeMore 100 * 1000 * 1000

if false
  console.log [n, Primes.isPrime n] for n in [2..30]

  gen = Primes.generator()

  console.log gen.next() for [1..10]

if false
  console.log Euler.intDiv 30, 2
  console.log (Euler.divisorsOf 30)

  console.log p357.ok n for n in [1..30]

  p357.ok 30, console.log

if false
  startedAt = Date.now()
  sum = 0
  for n in [1 .. 100 * 100]
    if p357.ok n
      sum += n
