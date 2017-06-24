register = [[false, true,  true,  false],
            [true,  false, true,  false],
            [true,  true,  false, true ],
            [false, false, true,  false]]

greatRenaming = (register) ->
  l = register.length
  rot = (n) -> (n + l - 1) % l

  register.map (row, y) ->
    row.map (connected, x) ->
      register[rot y][rot x]

Object.assign global, {register, greatRenaming}
