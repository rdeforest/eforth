# words -> { <picked>: <dist>: (recurse) }

proximity = (a, b) -> (x for x, i in a when b[i] is x).length

partition = (word, list) ->
  part = {}

  for other in list when other isnt word
    dist = proximity word, other
    part[dist] or= []
    part[dist].push other

  part

largestPart = (part) ->
  (p.length for dist, p of part)
    .reduce (a, b) -> if a < b then b else a

bestPartitions = (list) ->
  best = list.length
  contenders = {}

  for word in list
    part = partition word, list
    largest = largestPart part

    if largest < best
      best = largest
      contenders = {}

    if largest is best
      contenders[word] = part

  if contenders.length > 1 and false
    widest = Math.max contenders.map (c) -> (Object.keys c).length
    contenders = c for c in contenders when (Object.keys c).length is widest

  contenders

module.exports =
  best: bestPartitions
  part: partition
  largest: largestPart
