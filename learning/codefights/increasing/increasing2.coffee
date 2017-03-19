increasing = (l) ->
  n = l.shift()

  n = m while n < m = l.shift() and l.length

  not l.length

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
