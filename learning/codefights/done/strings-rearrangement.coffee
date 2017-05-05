offByN = (a, b, n) ->
  switch
    when a.length is 0 then n is 0
    when a[0] is b[0]  then offByN a[1..], b[1..], n
    when n > 0         then offByN a[1..], b[1..], n - 1

offByOne = (a, b) -> offByN a, b, 1

without = (nodes, idx) -> nodes.filter (n, i) -> i isnt idx

connected = (nodes) ->
  return [nodes] if nodes.length is 1
  return [nodes, nodes.reverse()] if nodes.length is 2 and offByOne nodes...

  paths = {}

  addPath = (p) ->
    s = JSON.stringify path
    rs = JSON.stringify path.reverse()

    paths[s] = p unless paths[s] or paths[rs]
    
  for node, i in nodes when (how = connected without nodes, i).length
    for path in how
      if offByOne node, path[0]       then addPath [node, path...]
      if offByOne node, path[-1..][0] then addPath [path..., node]

  path for key, path of paths

stringsRearrangement = (inputArray) ->
  paths = (connected inputArray)
  not not paths.length

# Object.assign global,
#   module.exports = { stringsRearrangement, connected, without, offByOne, offByN }
# 
# if true
#   (require './genericTester') [
#     [ [[ "aa",  "ab",  "bb"]], true]
#     [ [[ "ab",  "bb",  "aa"]], true]
#     [ [["aba", "bbb", "bab"]], false]
#     [ [["abc", "abx", "axx", "abc"]], false]
#     [ [[  "q",   "q"       ]], false]
#     [ [["ab", "ad", "ef", "eg"]], false]
#   ], stringsRearrangement
# 
