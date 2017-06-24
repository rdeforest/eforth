# multiples of 3 and 5

module.exports =
  (factors = [3, 5], start = 1, end = 10) ->
    total = 0

    for n in [start .. end - 1]
      if factors.find((f) -> not (n % f)) > -1
        total += n

    total
      
