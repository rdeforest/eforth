autoVivify = (o, path...) ->
  [prefix, name] = path

  for part in prefix
    o = o[part] or= {}

  o[name] = {}

class Maze
  constructor: (graph) ->
    {@exits, @copies} = graph
    @other = {}

    @completePaths surface, paths for surface, paths of graph

  completePaths: (surface, paths) ->

exampleMaze = new Maze
  exits:
    0:   in: a: 0
        out: [14, 15]
    1:   in: a: 3
    2:   in: a: 4, b: 6, c: 0
        out: [11]
    3:   in: b: 0

    4:   in: b: 3
    5:   in: b: 7
    6:   in: a: 2, c: 5
    7:   in: a: 10
        out: [12, 9]

    8:   in: b: 2
    10:  in: a: 13

  copies:
    a:
      7:  in: b: 15
      8:  in: c: 12
      9:  in: a: 15
      11: minus

    b:
      10: in: c: 3
      13: in: c: 14

    c:
      6: in: c: 7
      9: plus
