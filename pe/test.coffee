Primes = require './prime'
Euler = require './euler'
p357 = require './357'

lastNote = 0
updateInterval = 1000

note = (what...) ->
  lastNote = Date.now()
  console.log what...

maybeNote = (what...) ->
  if Date.now() - lastNote > updateInterval
    note what...

if false
  Primes.makeMore 100
  console.log Primes.known

  console.log [n, Primes.isPrime n] for n in [2..30]

  gen = Primes.generator()

  console.log gen.next() for [1..10]


  console.log Euler.intDiv 30, 2
  console.log (Euler.divisorsOf 30)

  console.log p357.ok n for n in [1..30]

  p357.ok 30, console.log

if false
  startedAt = Date.now()
  note 'startedAt', startedAt
  sum = 0
  for n in [1 .. 100 * 100]
    if p357.ok n
      sum += n
      #note '-> ' + n + ': ' + (Euler.divisorsOf n).join ' '

    maybeNote 'latest: ', n, sum

  note 'result: ', sum, Date.now() - startedAt

if true
  note 'result: ', p357.answer 10
