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

validCrosses = (across, down, from = -1) ->
  for c, x in across when x > from
    for y from charLocations down, c
      yield {-x, -y, across, down}

  return

valid = (fit, aCross, bCross) ->
  return false if bCross.y - fit.y < 2
  return false if fit.x - aCross.x < 2

  aChar = aCross.down[fit.x - aCross.x - bCross.x]
  bChar = bCross.across[fit.y + bCross.y]

  return aChar is bChar
  
crossFits = (aCross, bCross) ->
  fits = []

  for fit from validCrosses aCross.across, bCross.down, aCross.x
    unless valid fit, aCross, bCross
      continue

    # need better names for these 'Offset' vars
    topOffset  = aCross.y - bCross.y
    leftOffset = aCross.x - bCross.x

    topAcross =
      word: aCross.across
      x: if leftOffset >= 0 then 0 else -leftOffset
      y: Math.max aCross.y, bCross.y

    leftDown =
      word: aCross.down
      x: Math.max aCross.x, bCross.x
      y: if topOffset  >= 0 then 0 else -topOffset

    rightDown =
      word: bCross.down
      x: topAcross.x + fit.x
      y: if topOffset  <= 0 then 0 else  topOffset

    bottomAcross =
      word: bCross.across
      x: if leftOffset <= 0 then 0 else  leftOffset
      y: bCross.y + aCross.y - fit.y

    fits.push {topAcross, leftDown, rightDown, bottomAcross}
  fits

showPuzzle = (puzzle) ->
  console.log {topAcross, leftDown, rightDown, bottomAcross} = puzzle
  height = Math.max (leftDown.y  + leftDown.word.length ),
                    (rightDown.y + rightDown.word.length)

  for y in [0..height - 1]
    s = "#{yy = y.toString(); " ".repeat(2 - yy.length) + y}: "

    if y is topAcross.y
      console.log s + " ".repeat(topAcross.x) + topAcross.word
      continue

    if y is bottomAcross.y
      console.log s + " ".repeat(bottomAcross.x) + bottomAcross.word
      continue

    if 0 <= (idx = y - leftDown.y) < leftDown.word.length
      char = leftDown.word[idx]
      s += " ".repeat(leftDown.x) + char + " ".repeat rightDown.x - leftDown.x - 1
    else
      s += " ".repeat rightDown.x

    if char = rightDown.word[y - rightDown.y]
      s += char

    console.log s

  null

puzzles = (topAcross, leftDown, rightDown, bottomAcross) ->
  found = []

  for firstCross from validCrosses topAcross, leftDown
    for secondCross from validCrosses bottomAcross, rightDown
      [firstCross.y, secondCross.y] =
        [firstCross.y, secondCross.y].map (
          if offset = firstCross.y < secondCross.y
            [0, firstCross.y - secondCross.y]
          else
            [firstCross.y - secondCross.y, 0]
        )

      for fit from crossFits firstCross, secondCross # Pun intended?
        found.push fit
        height = Math.max firstCross.down.length  - firstCross.y,
                          secondCross.down.length - secondCross.y,
  found

countArrangements = (topAcross, leftDown, rightDown, bottomAcross) ->
  puzzles(arguments...).length

crosswordFormation = (words) ->
  count = 0
  count += countArrangements ordered... for ordered from permute words
  count

Object.assign global,
  module.exports = {
      crosswordFormation, countArrangements, puzzles,
      crossFits, valid, validCrosses, permute, charLocations, showPuzzle
  }
