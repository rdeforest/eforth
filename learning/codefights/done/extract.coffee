extractEachKth = (inputArray, k) ->
  inputArray.filter (e, i) -> (i + 1) % k
