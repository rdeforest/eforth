module.exports =
  pairOfShoes = (shoes) ->
    loners = {}
    unmatched = 0

    for [foot, size] in shoes
      if l = loners[size]
        if l[foot]
          loners[size][foot]++
          unmatched++
        else
          loners[size][foot]--
          unmatched--
      else
        (loners[size] = [])[foot] = 1
        unmatched++

    return not unmatched

