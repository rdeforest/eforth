test = require 'tape'

child_process = require 'child_process'

Primes = require '../prime'

getFactors = (n) ->
  new Promise (resolve, reject) ->
    output = ''
    child = child_process.spawn 'factor', n

    child.stderr.on 'data', (buffer) ->
      errText = buffer.toString()
      reject 'Error running "factor": ' + errText
    child.on 'error', (err) ->
      reject 'Error running "factor": ' + err

    child.stdout.on 'data', (buffer) -> output += buffer.toString()
    child.on 'close', ->
      [number, factors] = output.split ': '

      resolve (factors
                .split /\s+/
                .map  (s)    -> Number.parseInt s
                .sort (a, b) -> a - b)


module.exports = ->
  test 'isPrime', (t) ->
    t.plan 6

    for n in [2, 5, 17]
      t.ok (Primes.isPrime n), (n + " is prime")

    for n in [4, 1337, 65535]
      t.ok (Primes.isPrime n), (n + " is not prime")

  test 'factor', (t) ->
    t.plan 10
    testNumbers = [1..10].map -> Math.floor Math.random * 1000000

    for n in testNumbers
      actualFactors = getFactors n
      testFactors = Primes.factor n

      same = actualFactors.length is testFactors.length and
             actualFactors.map (n, i) -> n is testFactors[i]

      t.ok same, "factors of #{n} are #{actualFactors}"
