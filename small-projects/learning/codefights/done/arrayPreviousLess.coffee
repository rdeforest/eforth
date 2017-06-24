module.exports =
  arrayPreviousLess = (items) ->
    items.map (a, i) ->
      return -1 unless i

      if b = (items[..i - 1].reverse().find (b) -> b < a)
        return b
      else
        -1

