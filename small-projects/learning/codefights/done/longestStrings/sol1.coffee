
allLongestStrings = (l) ->
  cur = (ll = [l[0]])[0].length

  #console.log cur, ll

  for s in l[1..]
    switch
      when s.length > cur
        cur = s.length
        ll = [s]
      when s.length is cur
        ll.push s

  return ll

require('./tests') allLongestStrings
