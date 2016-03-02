autoVivify = (o, path...) ->
  [prefix, name] = path

  for part in prefix
    o = o[part] or= {}

  o[name] = {}

node = (name, number) -> "#{name}_#{number}"

edge  = (n) -> node  "", n
a     = (n) -> node "A", n
b     = (n) -> node "B", n
c     = (n) -> node "C", n

plus  = "plus"
minus = "minus"

  

class Maze
  constructor: (paths) ->
    @exits = {}
    @copies = {}
    @other = {}

    @addPaths from, destinations for from, destinations of paths

  parseNode: (nodeName) ->
    [surface, index] = nodeName.split '_'

    switch
      when not surface then @exits
      when not index   then autoVivify @other,  surface
                       else autoVivify @copies, surface, index


  addPaths: (fromName, destinations) ->
    from = parseNode fromName

    for to in destinations
      @addPath from, to
      @addPath to, from

  addPath: (fromName, toName) ->
    from = parseNode fromName
    [surface, index] = toName.split '_'

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
  a_11: [minus]

  b_10: [c 3]
  b_13: [c 14]

  c_6: [c 7]
  c_9: [plus]
