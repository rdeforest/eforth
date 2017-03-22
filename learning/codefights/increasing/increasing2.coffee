increasing = (l) ->
  n = l[0]
  l = l.slice 1

  while l.length and n < l[0]
    n = l.shift()

  return l.length is 0

almostIncreasingSequence = (seq) ->
  return true if seq.length < 3

  i = seq.length - 1

  i-- while i >= 0 and seq[i - 1] < seq[i]

  switch
    when i <= 1 then true
    when seq[i - 2] < seq[i    ] and increasing seq[..i - 2] then true
    when seq[i - 1] < seq[i + 1] and increasing seq[..i - 1] then true
    else false

require('./tests')(almostIncreasingSequence)
