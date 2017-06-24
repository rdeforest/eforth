isBeautifulString = (s) ->
  if not s then return true
  if -1 is s.indexOf 'a' then return false

  false isnt
    s .split ''
      .sort()
      #.map (e) -> console.log(e); e
      .reduce((
        (acc, c) ->
          if acc[0]?[0] is c
            acc[0][1]++
          else
            acc.unshift [c, 1]
          #console.log acc
          acc
      ), [])
      #.map (e) -> console.log(e); e
      .reduce(((prev, [c, n]) ->
        #console.log prev, c, n
        prev and
          if n < prev
            false
          else
            n
      ), -Infinity)

console.log isBeautifulString 'aabbb'
console.log isBeautifulString 'bbbcc'
