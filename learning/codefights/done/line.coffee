{stdout} = require 'process'
write = (s) -> stdout.write s

gcd = (n, m) -> if m < 1 then n else gcd m, n % m

countBlackCells = (n, m) ->
  [n,m] = [m,n] if m < n

  if (n is 1)
    return m

  #if (n is m)
  #  return n * 3 - 1

  return n + m + gcd(n, m) - 2

  (Math.floor((m + 1)/n) + 1) * n

#(require 'test') [
#  [ 33,  44,  86]
#  [  3,  44,  46]
#  [239, 749, 987]
#  [ 14, 234, 248]
#], countBlackCells

# 
# 1 x n = n
# 2 x n = Ceil(n/2) * 2
# 3 x n = Ceil(n/3) * n ?
# 
# ..
#  ..
#   ..
#    ..
# 
# ...
#   ...
#     ...
# 
# n: 239
# m: 749
# Output:
# 956
# Expected Output:
# 987
#
#
# ###
