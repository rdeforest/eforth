module.exports =
  cyclicString = (s) ->
    ss = s + s

    minLen = s
      .split('')
      .sort()
      .reduce (s, c) -> if c in s then s else s + c
      .length

    #console.log minLen

    for len in [minLen .. s.length]
      for c, i in s
        cycle = ss[i .. i + len - 1]
        #console.log len, cycle

        if -1 < cycle.repeat(s.length).indexOf s
          return len
