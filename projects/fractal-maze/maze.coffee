autoVivify = (o, path...) ->
  [prefix..., name] = path

  for part in prefix
    o = o[part] or= {}

  o[name] = {}

class Maze
  constructor: -> @boxes = {}

  addEdges: (args...) ->
    nodes = []

    for arg in args
      if 'object' is typeof arg
        for k, v of arg
          nodes.push [k, v]
      else
        nodes.push arg
    
    while nodes.length > 1
      [node, nodes...] = nodes

      for other in nodes
        @addEdge node, other

    this

  addEdge: (from, to) ->
    from = @normalize from
    to   = @normalize to

    autoVivify @boxes, from..., to...
    autoVivify @boxes, to..., from...

  normalize: (node) ->
    switch typeof node
      when 'number' then ['', node]
      when 'string' then [node, 0]
      else               node

  touching: (node) ->
    node = @normalize node
    touching = []

    for box, pin of @boxes[node[0]][node[1]
      touching.push [box, pin]

    touching

  extend: (node) ->

exampleMaze = new Maze

exampleMaze
  .addEdges  0, 14, 15, a: 0
  .addEdges  1, a: 3
  .addEdges  2, 11, a: 4, b: 6, c: 0
  .addEdges  3, b: 0

  .addEdges  4, b: 3
  .addEdges  5, b: 7
  .addEdges  6, a: 2, c: 5
  .addEdges  7, 9, 12, a: 10

  .addEdges  8, b: 2
  .addEdges 10, a: 13

  .addEdges a: 7, b: 15
  .addEdges a: 8, c: 12
  .addEdges a: 9, a: 15
  .addEdges a: 11, "minus"

  .addEdges b: 10, c: 3
  .addEdges b: 13, c: 14

  .addEdges c: 6, c: 7
  .addEdges c: 9, "plus"

module.exports =
  autoVivify: autoVivify
  Maze: Maze
  example: exampleMaze
