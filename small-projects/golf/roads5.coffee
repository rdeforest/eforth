sharedCity = (a, b) ->
  ends = b[0..1]
  a[0] in ends or a[1] in ends

namingRoads = (roads) ->
  return false if roads.length < 4

  roads = (roads.sort (a,b) -> a[2] - b[2]).concat [roads[0]]

  for road, idx in roads[1..-2]
    return false if sharedCity road, roads[idx]
    return false if sharedCity road, roads[idx + 2]

  return true

roads = [[0, 1, 0],
         [4, 1, 2],
         [4, 3, 4],
         [2, 3, 1],
         [2, 0, 3]]

Object.assign global, {sharedCity, namingRoads, roads}
