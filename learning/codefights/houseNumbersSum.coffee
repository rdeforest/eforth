module.exports =
  houseNumbersSum = ([next, rest...]) ->
    if next
      next + houseNumbersSum rest
    else
      0
