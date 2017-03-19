increasing = (l) ->
  return l.length < 2 or
         (l[0] < l[1] and increasing l[1..])

almostIncreasingSequence = (l) ->
  return true if l.length < 3

  [n0, n1, n2] = l

  if n0 < n1 < n2
    return almostIncreasingSequence l[1..]

  #console.log "ai:", l

  if n0 < n2
    #console.log "remove #{n1}"
    return increasing l[2..]

  if n1 < n2
    #console.log "remove #{n0}"
    return increasing l[1..]

  if n0 < n1 > n2
    return true if l.length is 3

    if n1 < n3 = l[3]
      return increasing l[3..]

  return false

require('./tests')(almostIncreasingSequence)
