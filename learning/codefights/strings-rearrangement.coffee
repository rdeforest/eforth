offByN = (a, b, n) ->
  switch
    when a.length is 0 then n is 0
    when a[0] is b[0]  then offByN a[1..], b[1..], n
    when n > 0         then offByN a[1..], b[1..], n - 1

offByOne = (a, b) -> offByN a, b, 1

without = (nodes, node) -> nodes.filter (n) -> n isnt node

connected = (nodes) ->
  return [nodes] if nodes.length is 1
  return [nodes, nodes.reverse()] if nodes.length is 2 and offByOne nodes...

  paths = []

  for node in nodes when (how = connected without nodes, node).length
    for path in how
      if offByOne node, path[0]       then paths.push [node, path...]
      if offByOne node, path[-1..][0] then paths.push [path..., node]

  paths

stringsRearrangement = (inputArray) ->
  not not (connected inputArray).length

Object.assign global,
  module.exports = { stringsRearrangement, connected, without, offByOne, offByN }

if true
  (require './genericTester') [
    [ [[ "aa",  "ab",  "bb"]], true]
    [ [[ "ab",  "bb",  "aa"]], true]
    [ [["aba", "bbb", "bab"]], false]
    [ [[  "q",   "q"       ]], false]
    [ [["ab", "ad", "ef", "eg"]], false]
  ], stringsRearrangement

