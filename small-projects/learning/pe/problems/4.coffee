###

Largest palindrome product

A palindromic number reads the same both ways. The largest palindrome made
from the product of two 2-digit numbers is 9009 = 91 × 99.

Find the largest palindrome made from the product of two 3-digit numbers.

###


module.exports =
  (digits = 3) ->
    to = (from = 10 ** (digits - 1)) * 10 - 1
    max = 0

    for a in [from .. to]
      n = a * a - a

      for b in [a .. to]
        n += a

        if (nStr = n.toString()).split("").reverse().join("") is nStr
          if n > max
            max = n

    return max
