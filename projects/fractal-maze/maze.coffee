autoVivify = (o, path..., value) ->
  [prefix..., name] = path

  for part in prefix
    o = o[part] or= {}

  o[name] = value

class Maze
  constructor: ->
    # @paths[fromBox][fromPin][toBox][toPin] is path between them
    @paths = {}

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

  addPath: (from, to, path) ->
    autoVivify @paths, from..., to..., path
    autoVivify @paths, to..., from..., path.reverse()

  normalize: (node) ->
    switch typeof node
      when 'number' then ['', node]
      when 'string' then [node, 0]
      else
        if node.length is 2
          node
        else
          [k] = Object.keys node
          [k, node[k]]

  touching: (node) ->
    [nodeBox, nodePin] = @normalize node
    touching = []

    for box, pins of @paths[nodeBox][nodePin]
      for pin of Object.keys pins
        path = @paths[nodeBox][nodePin][box][pin]
        touching.push [box, pin, path]

    touching

  extend: (node) ->
    for [nearBox, nearPin, nearPath] in @touching node
      for [farBox, farPin, farPath] in @touching [nearBox, nearPin] when farBox isnt node[0] or farPin isnt node[1]
        newPath = nearPath.concat farPath
        @addPath node, [farBox, farPin], newPath

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
