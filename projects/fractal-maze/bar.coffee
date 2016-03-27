paths = {}

queryWire = (from, to, tellMe) ->
  from = JSON.stringify from
  to = JSON.stringify to

  paths[from] ?= {}
  answer = paths[from][to]
  if answer is undefined
    return paths[from][to] =
      asking: [tellMe]

  if answer.asking
    answer.asking.push tellMe
    return answer

  tellMe answer

defineWire = (ends...) ->
  [from, to] =
    ends
      .map (e) -> JSON.stringify e
      .sort()
  
  paths[from] ?= {}
  query = paths[from][to]
  if query and query.asking
    query.asking.map (a) -> a []

  paths[from][to] = []

wire = (ends...) ->
  for from, idx in ends
    for to in ends[idx+1..]
      defineWire from, to

throughBox = (from, to) ->
  return false unless 'object' is typeof from
  return false unless 'object' is typeof to

  (Object.keys from)[0] is (Object.keys to)[0]

test = (path) ->
  to = path.shift()
  steps = []

  while path.length > 1
    [from, to] = [to, path...]
    from = to
    to = path.shift()
    if throughBox from, to
      steps.push paths[from.pin][to.pin]

  Promise.all steps
    .then (paths) ->
      console.log paths

wire  0, 14, 15, a: 0
wire  1, a: 3
wire  2, 11, a: 4, b: 6, c: 0
wire  3, b: 0

wire  4, b: 3
wire  5, b: 7
wire  6, a: 2, c: 5
wire  7, 9, 12, a: 10

wire  8, b: 2
wire 10, a: 13

wire a: 7, b: 15
wire a: 8, c: 12
wire a: 9, a: 15
wire a: 11, "minus"

wire b: 10, c: 3
wire b: 13, c: 14

wire c: 6, c: 7
wire c: 9, "plus"

module.exports =
  paths: paths
  wire: wire
  test: test
  queryWire: queryWire
  defineWire: defineWire
  throughBox: throughBox
