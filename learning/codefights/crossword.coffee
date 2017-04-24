charLocations = (word, c) ->
  from = -1

  while -1 < i = word.indexOf c, from
    yield i
    from = i

permuteWords = (words) ->
  if words.length is 1
    yield [words]
    return

  for word, i in words
    rest = words.slice()
    rest.splice(i,1)

    for tail from permuteWords rest
      yield [word, tail...]

addDown = (across, down, from = -1) ->
  for c, i in across when i > from
    for j from charLocations down, c
      yield i, -j

puzzles = (topAcross, leftDown, rightDown, bottomAcross) ->
  one = [[topAcross, 0, 0]]
  found = []

  for [x, y] from addDown topAcross, leftDown
    two = one.concat [[leftDown, x, -y]]

    for [x, y] from addDown topAcross, rightDown, x + 1
      three = two.concat [[rightDown, k, -j]]

countArrangements = (topAcross, leftDown, rightDown, bottomAcross) ->
  puzzles(arguments).length

crosswordFormation = (words) ->
  count = 0
  count += countArrangements ordered... for ordered from permuteWords words
