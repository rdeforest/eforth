# https://codefights.com/arcade/graphs-arcade/kingdom-roads/ty4w8WJZ4sZSBNK5Q

# if test(a, b) or test(b, a)
# if either(test) a, b
either = (test) ->
  (x, y) -> test(x, y) or test(y, x)

same = (x, y) -> x is y

direct = (roads) ->
  either (x, y) ->
    for [a, b] in roads
      return true if x is a and y is b

oneHop = (cities, roads) ->
  either (x, y) ->
    return true if direct(roads) x, y

    for hop in [0..cities - 1] when hop not in [x, y]
      # console.log "Checking hop #{hop}"
      if direct(roads)(x, hop)
        if direct(roads)(hop, y)
          return true
        else
          # console.log "#{hop} not connected to y #{y}"
      else
        # console.log "x #{x} not connected to #{hop}"

efficientRoads = (n, roads) ->
  check = oneHop n, roads

  for src in [0..n - 2]
    for dst in [src + 1 .. n - 1] when not check src, dst
      # console.log "No, because", src, dst
      return false

  return true

#test = (e, t) -> if e is t then "ok" else "fail"

#console.log test true,  efficientRoads 6, roads = [[3, 0], [0, 4], [5, 0], [2, 1], [1, 4], [2, 3], [5, 2]]
#console.log test false, efficientRoads 6, roads[1..]

#module.exports = {either, same, direct, oneHop, efficientRoads, roads}
