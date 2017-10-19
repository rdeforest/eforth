MAXGEN      = 100

process     = require 'process'

R           = require 'ramda'

total       =
count       =
lastUpdate  =
mostFactors = 0

log = (args...) ->
  if (Date.now() - lastUpdate) > 1000
    console.log args...
    lastUpdate = Date.now()

require('rdf/lib/number') Number

knownGenerators    = new Set
knownNonGenerators = new Set

isGenerator = (n) ->
  console.log "checking #{n}"

  halfN = n >> 1
  pd = 0

  for d in n.divisors()
    break if pd and pd > d
    pd = d

    unless (divided = d + (n / d)).isPrime()
      console.log "Disqualified #{n}: #{d} + (#{n}/#{d}) = #{divided}, which isn't prime"
      return false

  true

candidateMaker = (from = 3, currentProduct = 2, max = MAXGEN) ->
  primes = Number.primes
  realMax = Math.floor max / currentProduct

  loop
    p = primes.next().value
    break if p >= from

  loop
    return if p > realMax

    q = currentProduct * p

    p = primes.next().value

    yield q
    yield from candidateMaker p, q, max

doit = ->
  for n from candidateMaker()
    log n, count, total

    if isGenerator n
      count++
      total += n

  console.log count, total

Object.assign module.exports, { doit, candidateMaker, isGenerator }
