STARTGEN = 6
HOWMANY  = 10000
MAXGEN   = STARTGEN + HOWMANY

process = require 'process'

R = require 'ramda'

require('./lib/number') Number
require('./lib/array')  Array

knownGenerators = new Set
knownNonGenerators = new Set

isGenerator = (n, verbose) ->
  factors = n.factors()

  # 1 + prime/1 = prime + 1
  # which is divisible by 2
  return false if n.length is 0

  # n + n*n*p*q/n = n + n*p*q = n*(q*p+1)
  # which is divisible by n (and also 2, but that's less obvious)
  return false if hasDupe factors

  # let g be a found generator
  # let p and q be factors of g
  # g + p cannot be a generator because it is p * (q + 1)
  # q + 1 is even because q is prime
  #
  # BUT! when p isnt 2, g + p is odd and can be ignored,
  # so instead we skip g + p * 2, g + p * 4, etc
  #
  # for p in factors[1..]
  #   n2 = n + (p2 = p * 2)
  #
  #   while n2 < MAXGEN
  #     knownNonGenerators.add n2
  #     n2 += p2

  for f in factors
    return false if knownGenerators.has n - f * 2

  halfN = n >> 1

  for d in n.divisors()
    unless (divided = d + (n / d)).isPrime()
      return false

    break if d >= halfN

    #console.log "#{d} + #{n}/#{d} = #{divided}" if verbose

  knownGenerators.add n

  #   while q < MAXGEN
  #     knownNonGenerators[q] = true
  #     q += p

  true

total       =
count       =
lastUpdate  =
mostFactors = 0

n = STARTGEN - 4
n++ until isGenerator n

while n < MAXGEN
  if isGenerator n, false
    count++
    total += n

    if mostFactors < (f = n.factors()).length
      mostFactors = f.length

    if (Date.now() - lastUpdate) > 1000
      console.log n, mostFactors, count, total, f
      lastUpdate = Date.now()

  n += 4

console.log count, total
