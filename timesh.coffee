process = require 'process'

{spawn} = child_process = require 'child_process'

defaultCmd = 'for f in {1..100}; do /bin/true; done'

[ shell
  rounds = 10
  cmd = defaultCmd
] = process.argv[2..]

time = ->
  new Promise (resolve, reject) ->
    start = new Date
    child = spawn shell, [ "-c", cmd]
    child.on 'close', -> resolve new Date - start
    child.on 'error', (err) -> reject err

doRounds = (timings = [], rounds) ->
  if arguments.length < 2
    rounds = timings
    timings = []

  time()
    .then (t) ->
      console.log t
      timings.push t

      if timings.length < rounds
        doRounds timings, rounds
      else
        timings

pN = (l, n) ->
  portion = Math.ceil (l.length * n / 100)
  l = l.sort (a, b) -> a - b
  console.log l, n, portion
  l[portion]

p90 = (l) -> pN l, 90

doRounds rounds
  .then (timings) ->
    console.log timings
    sum = timings.reduce (a, b) -> a + b
    console.log avg = sum / rounds
    console.log p90 timings

