charLocations = (word, c) ->
  from = 0

  while -1 < i = word.indexOf c, from
    yield i
    from = i + 1

  return

permute = (items) ->
  if items.length is 1
    yield items
    return

  for word, i in items
    rest = items.slice()
    rest.splice i, 1

    for tail from permute rest
      yield [word, tail...]

  return

findIntersections = (a, b, after = -1) ->
  for c, i in a when i > after


