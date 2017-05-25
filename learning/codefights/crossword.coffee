class Scrabble
  constructor: (@board = [[]], word, x, y, down) ->
    if not @board.length
      @board = [[]]

    if word
      @add word, x, y, down

  add: (word, x, y, down) ->
    @accomodate word, x, y, down

  accomodate: (word, x, y, down) ->
    bottom = y + if down then word.length - 1 else 0

    if 0 < add = y + 1 - @height()
      @board.concat [1..add].map @board[0].map -> ' '

    right = x + if down then 0 else word.length - 1
    add = right - @width

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


