autoVivify = (o, path, value) ->
  [prefix, name] = path

  for part in prefix
    o = o[part] or= {}

  o[name] = value

makeTrue = (o, path) -> autoVivify o, path, true

node = (name, number) -> "#{name}_#{number}"

edge = (n) -> node "edge", n
a    = (n) -> node "inA", n
b    = (n) -> node "inB", n
c    = (n) -> node "inC", n
plus = "plus"
minus = "minus"

class Maze
  constructor: (paths) ->
    @doors = {}

    @addPath from, destinations for from, to of paths

  addPath: (from, destinations) ->
    [surface, index] = from.split '_'
    

exampleMaze = new Maze
  edge_0: [edge 15, edge 14, a 0]
  edge_1: [a 3]
  edge_2: [a 4, b 6, c 0, edge 11]
  edge_3: [b 0]

  edge_4: [b 3]
  edge_5: [b 7]
  edge_6: [a 2, c 5]
  edge_7: [a 10, edge 12, edge 9]

  edge_8: [b 2]
  edge_10: [a 13]

  a_7: [b 15]
  a_8: [c 12]
  a_9: [a 15]
  a_11: ["minus"]

  b_10: [c 3]
  b_13: [c 14]

  c_6: [c 7]
  c_9: ["plus"]
