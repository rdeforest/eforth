Array::last = -> @slice -1

addEdgeToNet = (net, edge, path = []) ->
  net = [head, branches...]
  [a, b] = edge

  switch
    if -1 < idx = path.indexOf head
      if idx % 2 == 1
        throw "not magic"

      return net

    when head is a
      newNet = [b, [head, tails]]

    else
      newNet = [head, tails.map (net) -> addEdge net, edge, [path..., head]

isWoodMagical = (n, wmap) ->
  nets = []

  for edge in wmap
    nets = addEdge nets, edge

console.log isWoodMagical 5, [[1, 2], [1, 3], [1, 4], [0, 2], [4, 0]]
console.log isWoodMagical 5, [[1, 2], [1, 3], [1, 4], [0, 2], [4, 0], [1, 0]]
