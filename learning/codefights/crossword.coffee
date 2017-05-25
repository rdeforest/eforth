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
  from = -1

  while -1 < i = word.indexOf c, from + 1
    yield i
    from = i

  return

permute = (items) ->
  if items.length is 1
    yield items
    return

  for word, i in items
    rest = items.slice()
    rest.splice(i,1)

    for tail from permute rest
      yield [word, tail...]

  return

addDown = (across, down, after = -1) ->
  for c, x in across when x > after
    for y from charLocations down, c
      yield {across, down, x, y}

addBottom = (top, left, right, bottom, leftX, leftY, rightX, rightY) ->
  maxY = Math.max leftY + left.length, rightY + right.length
  topY = Math.max leftY, rightY

  for y in [topY + 2..maxY]
    rightChar = right[y - rightY]
    for bottomIdx charLocations bottom, c
      bottomX = leftX - bottomIdx

      if rightChar is c
        if bottomX < 0
          topX = -bottomX
          bottomX = 0
        else
          topX = bottomX - leftX

        yield {
        }
