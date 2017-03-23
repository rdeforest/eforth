increasing = (l, from = 0, to = l.length - 1) ->
  p = l[from]

  for n in l.slice(from + 1, to + 1)
    if n <= p
      return false
    p = n

  return true

almostIncreasingSequence = (seq) ->
  return true if seq.length < 3

  if not increasing seq[-2..]
    return increasing seq, 0, seq.length - 2

  if not increasing seq[0..1]
    return increasing seq, 1, seq.length - 1

  i = seq.length - 1

  i-- while i >= 0 and seq[i - 1] < seq[i]

  switch
    when i <= 1 then true
    when seq[i - 2] < seq[i    ] and increasing seq[..i - 2] then true # delete i - 1
    when seq[i - 1] < seq[i + 1] and increasing seq[..i - 1] then true # delete i
    else false

require('./tests')(almostIncreasingSequence)

module.exports = {almostIncreasingSequence, increasing}
