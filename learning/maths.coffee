gcd = (a, b) -> if b is 0 then a else gcd b, a % b

expmod = (base, exp, mod) ->
  switch
    when not exp then 1
    when exp % 2 then (base * expmod(base, exp - 1, mod)) % mod
    else
      p = expmod base, exp / 2, mod
      (p * p) % mod

