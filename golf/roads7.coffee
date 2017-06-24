makeCities = (n, roads) ->
  cities = Array(n).fill(0).map (zero, id) -> {id, fell: -1, peers: new Set}

  for [from, to] in roads
    cities[from].peers.add to
    cities[to]  .peers.add from

  cities

citiesConquering = (n, roads) ->
  cities = makeCities n, roads

  day = 1

  vulnerable = ({fell, peers}) -> fell is -1 and peers.size < 2

  loop
    break unless (victims = cities.filter vulnerable).length

    for v in victims
      v.fell = day
      v.peers.forEach (p) ->
        p = cities[p]
        p.peers.delete v.id

    day++

  cities.map ({fell}) -> fell
