# Create a map, look for patterns?

seen = []
remember = (n, info = {}) ->
  seen[n] = info

cSeries = (start) ->
  n = start
  max = n
  min = n
  steps = 0

  loop
    if n is 1 then
      remember {start, min, max}
      return

    if before = seen[n]
      {smin, smax, ssteps} = before
      min = Math.min min, smin
      max = Math.max max, smax
      remember {start, min, max, steps + ssteps}

    steps++

    if n < min then min = n

    if n % 2
      n = n * 3 + 1

    n >> 1 until n % 2

    if n > max then max = n

    yield n
