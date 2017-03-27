boxBlur = (image) ->
  height = image.length - 3
  width  = image[0].length - 3

  blurred =
    [0..height].map (y) ->
      [0..width].map (x) ->
        Math.floor(([].concat image[y  ][x..x+2]
                      .concat image[y+1][x..x+2]
                      .concat image[y+2][x..x+2]
                      .reduce (a, b) -> a + b) / 9
        )

(require './genericTester') [
  [[
    [[1,1,1],[1,7,1],[1,1,1]]
   ]
   [[1]]
  ]
  [
    [
      [[36, 0,18, 9, 9,45,27],
       [27, 0,54, 9, 0,63,90],
       [81,63,72,45,18,27, 0],
       [ 0, 0, 9,81,27,18,45],
       [45,45,27,27,90,81,72],
       [45,18, 9, 0, 9,18,45],
       [27,81,36,63,63,72,81]]
    ]
    [[39,30,26,25,31],
     [34,37,35,32,32],
     [38,41,44,46,42],
     [22,24,31,39,45],
     [37,34,36,47,59]]
  ]
], boxBlur

nineInts = -> [1..9].map -> Math.floor Math.random() * 256
before = (l) -> Math.floor((l.map (n) -> n/9).reduce (a, b) -> a + b)
after = (l) -> Math.floor(l.reduce((a, b) -> a + b) / 9)
diff = (l) -> before(l) - after l
diff [1..9].map -> Math.floor Math.random() * 256
chk = (l) -> if (d = Math.abs diff l) > 0 then console.log "[ #{l.join(", ")} ] : #{d}" else null
search = -> (i = 0; null while i++ < 100 and null is chk nineInts()); i

