
Array::without = (i) -> (l = @slice()).splice i, 1; l
Object.defineProperties Number::, spaces: get: -> ' '.repeat Math.abs @

module.exports =
  charLocations: (word, char) -> i for c, i in word when c is char

  permutations: (items) ->
    if items.length is 1
      items
    else
      permuted = []

      for word, i in items
        for tail in permutations items.without i
          permuted.push [word].concat tail

      permuted

  intersections: intersections = (a, b) ->
    found = []

    for char, aIdx in a
      for bIdx in charLocations b, char
        found.push {aIdx, bIdx}

    found

  ladders: (rung, left, right) ->
    found = []

    for upperLeft in intersections rung, left
      for upperRight in intersections rung, right when upperRight.aIdx >= upperLeft.aIdx + 2
        found.push {upperLeft, upperRight}

    found

  validIntersect: (horizontal, vertical, offsets) ->
    horizontal[offsets.aIdx] and (horizontal[offsets.aIdx] is vertical[offsets.bIdx])

  puzzles: (top, left, right, bottom) ->
    found = []

    for {upperLeft, upperRight} in ladders top, left, right
      width = upperRight.aIdx - upperLeft.aIdx

      for lowerLeft in intersections bottom, left when 2 <= height = lowerLeft.bIdx - upperLeft.bIdx
        lowerRight = aIdx: lowerLeft.aIdx + width, bIdx: upperRight.bIdx + height

        if validIntersect bottom, right, lowerRight
          found.push {top, left, right, bottom, upperLeft, upperRight, lowerLeft, lowerRight}

    found

  crosswordFormation: (words) ->
    count = 0

    for permutation in permutations words
      for puzzle in puzzles permutation...
        count++

    count

  show: (puzzle) ->
    {top, left, right, bottom, upperLeft, upperRight, lowerLeft, lowerRight} = puzzle

    upperLeft  = Object.assign {}, upperLeft
    upperRight = Object.assign {}, upperRight
    lowerLeft  = Object.assign {}, lowerLeft
    lowerRight = Object.assign {}, lowerRight

    if 0 > otherWordStartsAt = upperLeft.aIdx - lowerLeft.aIdx
      top = otherWordStartsAt.spaces + top

      upperLeft.aIdx  -= otherWordStartsAt
      upperRight.aIdx -= otherWordStartsAt
    else if otherWordStartsAt
      bottom = otherWordStartsAt.spaces + bottom

      lowerLeft.aIdx  += otherWordStartsAt
      lowerRight.aIdx += otherWordStartsAt

    if 0 > otherWordStartsAt = upperLeft.bIdx - upperRight.bIdx
      left = otherWordStartsAt.spaces + left

      upperLeft.bIdx -= otherWordStartsAt
      lowerLeft.bIdx -= otherWordStartsAt
    else if otherWordStartsAt
      right = otherWordStartsAt.spaces + right

      upperRight.bIdx += otherWordStartsAt
      lowerRight.bIdx += otherWordStartsAt

    if 0 > lengthDiff = left.length - right.length
      left  += lengthDiff.spaces
    else
      right += lengthDiff.spaces

    y = 0
    leftPad = upperLeft.aIdx.spaces
    middlePad = (upperRight.aIdx - upperLeft.aIdx - 1).spaces

    loop
      switch
        when y is upperLeft.bIdx then yield top
        when y is lowerLeft.bIdx then yield bottom
        else
          yield leftPad + (left[y] or ' ') + middlePad + (right[y] or ' ')

      y++
      break if y >= left.length

  times: []
  words: 'crossword square formation something'.split ' '
  memoize: memoize = (name, fn) ->
    console.log "memoizing #{name}"
    memory = {}

    module.exports[name] = (args...) ->
      memory[JSON.stringify args] or= fn args...

# for name, fn of module.exports
#   if 'function' is typeof fn
#     memoize name, fn
#   else
#     console.log "not memoizing #{name}"

memoize 'intersections', intersections

Object.assign global, module.exports

