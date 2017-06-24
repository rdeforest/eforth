phoneCall = (min1, min2_10, min11, s) ->
  return 0 if s < min1 #?!
  s -= min1

  if s <= min2_10 * 9
    return 1 + Math.floor s / min2_10

  s -= min2_10 * 9

  return 10 + Math.floor s / min11
