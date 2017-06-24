avoidObstacles = (inputArray) ->
  sieve = [2..41]

  for n in inputArray
    sieve = sieve.filter (jump) -> jump > n or n % jump isnt 0

  sieve[0]
