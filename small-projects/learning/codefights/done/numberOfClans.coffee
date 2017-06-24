divisorPattern = (n, divisors) ->
  divisors
    .map (d) -> n % d and 1
    .reduce ((acc, nonDivisor) -> acc * 2 + nonDivisor), 0

module.exports = numberOfClans = (divisors, k) ->
  [1..k]
    .map (n) -> divisorPattern n, divisors
    .reduce ((patterns, pattern) -> patterns.add pattern), new Set
    .size

###

# Looks better in the original CoffeeScript:

divisorPattern = (n, divisors) ->
  divisors
    .map (d) -> n % d and 1
    .reduce ((acc, nonDivisor) -> acc * 2 + nonDivisor), 0

module.exports = numberOfClans = (divisors, k) ->
  [1..k]
    .map (n) -> divisorPattern n, divisors
    .reduce ((patterns, pattern) -> patterns.add pattern), new Set
    .size

###
