increasing = (l) ->
  n = l[0]
  l = l.slice

  while l.length and n < l[0]
    n = l.shift()

  return l.length is 0

almostIncreasingSequence = (l) ->
  return true if l.length < 3

  [n0, n1, n2] = l

  if n0 < n1 < n2
    return almostIncreasingSequence l[1..]

  if n0 < n2
    return increasing l[2..]

  if n1 < n2
    return increasing l[1..]

  if n0 < n1 > n2
    return true if l.length is 3

    if n1 < n3 = l[3]
      return increasing l[3..]

  return false

require('./tests')(almostIncreasingSequence)
