digitsProduct = (product) ->
  digits = new Array(10).fill 0

  if 0 is p = product then return 10

  if p < 10 then return p

  while p > 1
    for factor in [9, 8, 6, 4, 2, 3, 5, 7, 1]
      if 0 is p % factor
        break

      console.log p, factor, p % factor

    if factor is 1
      return -1

    #console.log p, factor,
    p /= factor
    digits[factor]++
    console.log digits

  #while digits[3] > 2
  #  digits[3] -= 2
  #  digits[9]++

  #while digits[2] and digits[3]
  #  digits[2]--
  #  digits[3]--
  #  digits[6]++

  #while digits[2] > 2
  #  digits[2] -= 2
  #  digits[4]++


  result = ""
  t = 1

  for c, d in digits when c
    t *= d**c
    result = "#{result}#{d.toString().repeat c}"

  console.log product, t, result, digits

  if t isnt product
    throw new Error "bug"

  parseInt result

(require './done/genericTester') [
  [[12], 26]
], digitsProduct
