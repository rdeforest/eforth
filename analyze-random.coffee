# Analize a random number generator

dieSize = 6

generator = -> Math.floor Math.random() * dieSize

seq = []
seq.push generator()
seq.push generator()
seq.push generator()

NSpace = require './nspace'

chains = new NSpace seq.length

lastUpdate = Date.now

updateInterval = 1000 # milliseconds

postUpdate = ->
  max = 0
  min = undefined
  count = 0

  chains.deepScan (value, coords) ->
    count++
    total += value
    min = if min is undefined then value else Math.min min, value
    max = Math.max max, value

  mean = total / count

  console.log
    min: min
    mean: mean
    max: max

maybeUpdate = ->
  elapsed = Date.now - lastUpdate

  if elapsed > updateInterval
    postUpdate()
    lastUpdate = Date.now

###
loop
  seq = seq[1..] + [generator()]

  chains.incr seq

  maybeUpdate()
###
