comb2mask = (str) ->
  str
    .split ''
    .map (c) -> {"*": 1, ".": 0}[c]
    .reduce ((mask, bit) -> (mask << 1) + bit)

combs = (comb1, comb2) ->
  if comb1.length < comb2.length
    [comb2, comb1] = [comb1, comb2]

  [mask1, mask2] = [comb1, comb2].map comb2mask

  [-comb1.length + 1 .. comb2.length - 1]
    .map (offset) ->
      [top, bottom] = [mask1, mask2]

      diff = comb2.length - comb1.length

      switch
        when offset < diff
          len = comb2.length - offset
          top >>= -offset
        when offset < 0
          len = comb1.length
          top >>= -offset
        else
          len = comb1.length + offset - diff
          bottom >>= offset

      both = top & bottom

      {offset, len, top, bottom, both}

   .filter ({offset, len, top, bottom, both}) ->
     console.log offset
     [ top, bottom, both ]
       .map((n) -> (65536 + n).toString(2))
       .forEach (n) -> console.log n

     return both is 0

   .sort (a, b) -> a.len - b.len
   .shift()
   .len

module.exports = combs
