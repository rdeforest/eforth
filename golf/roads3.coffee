# https://codefights.com/arcade/graphs-arcade/kingdom-roads/ty4w8WJZ4sZSBNK5Q

efficientRoads = (n, roads) ->
  if n < 2 then return true

  connected = (0 for y in [0..n - 1] for x in [0..n - 1])

  connect = (a, b, d) -> connected[a][b] = connected[b][a] = d

  connect x, x, 3 for x in [0..n - 1]

  for [src, dst] in roads
    connect src, dst, 1

  for [src, hop] in roads
    for yep, dst in connected[hop]
      connect src, dst, 2

  console.log connected

  for c in [0..n - 1]
    for d in connected[c] when not d
      return false

  return true

test = (e, t) -> if e is t then "ok" else "fail"

console.log test true,  efficientRoads 6, [[3, 0], [0, 4], [5, 0], [2, 1], [1, 4], [2, 3], [5, 2]]
console.log test false, efficientRoads 6, [        [0, 4], [5, 0], [2, 1], [1, 4], [2, 3], [5, 2]]
