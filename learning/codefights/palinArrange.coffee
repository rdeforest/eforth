palindromeRearranging = (s) ->
  counts =
   s.split ''
    .sort()
    .reduce ((a, c) -> a[c] = (a[c] or 0) + 1; a), {}
  
  (k for k, v of counts when v % 2).length < 2

require('./genericTester') [
  [['aabb'], true]
  [['cat'], false]
], palindromeRearranging
