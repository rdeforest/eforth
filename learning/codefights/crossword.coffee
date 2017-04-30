charLocations = (word, c) ->
  from = -1

  while -1 < i = word.indexOf c, from
    yield i
    from = i

permute = (items) ->
  if items.length is 1
    yield [items]
    return

  for word, i in items
    rest = items.slice()
    rest.splice(i,1)

    for tail from permute rest
      yield [word, tail...]

addDown = (across, down, from = -1) ->
  for c, x in across when x > from
    for y from charLocations down, c
      yield {across, down, x, y}

valid = (fit, aCross, bCross) ->
  {x, y} = fit
  aChar = aCross.down[]
  bChar = bCross.across[]
  
crossFits = (aCross, bCross) ->
  for fit from addDown aCross.across, bCross.down when valid fit, aCross, bCross
    topAcross:    word: aCross.across, x: 0,        y: aCross.y
    leftDown:     word: aCross.down,   x: aCross.x, y: 0
    rightDown:    word: bCross.down,   x: fit.x,    y:
    bottomAcross: word: bCross.across, x: ,         y: fit.y


puzzles = (topAcross, leftDown, rightDown, bottomAcross) ->
  found = []

  for firstCross from addDown topAcross, leftDown
    for secondCross from addDown bottomAcross, rightDown
      for fit from crossFits firstCross, secondCross # Pun intended?
        found.push fit

  found

countArrangements = (topAcross, leftDown, rightDown, bottomAcross) ->
  puzzles(arguments).length

crosswordFormation = (words) ->
  count = 0
  count += countArrangements ordered... for ordered from permuteWords words

###
 f
 o
crossword
 m
 a
 t
 i
 o
 n

[1, 2]


   s
   q
   u
   a
   r
something

x: 3
y: 4

fit = x: 3, y: 0

###
