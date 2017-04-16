offByN = (a, b, n) ->
  switch
    when a.length is 0 then n is 0
    when a[0] is b[0]  then offByN a[1..], b[1..], n
    when n > 0         then offByN a[1..], b[1..], n - 1

offByOne = (a, b) -> offByN a, b, 1

without = (graph, node) -> graph.filter ([n]) -> n isnt node

connected = ([[node, neighbors], graph...]) ->
  console.log arguments[0]

  return [[], [node]] unless graph.length

  [paths, failed] = connected graph

  if not neighbors.length
    return [paths, failed.concat [node]

  end = paths[0].length - 1

  extended = []

  for path in paths
    for neighbor in neighbors when -1 < idx = (path.indexOf neighbor)
      if idx is 0   then extended.push [node, path...]
      if idx is end then extended.push [path..., node]

  if extended.length
    return extended

  false

makeGraph = (words) ->
  graph = words.map (w, i) -> [i, []]

  for [w, wEdges], i in graph
    for [x, xEdges], j in graph when j > i and offByOne words[i], words[j]
      wEdges.push j
      xEdges.push i

  graph

stringsRearrangement = (inputArray) ->
  not not connected makeGraph inputArray

Object.assign global,
  module.exports = { stringsRearrangement, connected, without, offByOne, offByN, makeGraph }

if true
  (require './genericTester') [
    [ [[ "aa",  "ab",  "bb"]], true]
    [ [[ "ab",  "bb",  "aa"]], true]
    [ [["aba", "bbb", "bab"]], false]
    [ [[  "q",   "q"       ]], false]
    [ [["ab", "ad", "ef", "eg"]], false]
  ], stringsRearrangement

