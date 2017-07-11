module.exports =
  boxBlur = (image) ->
    image[1..-2].map (line, y) ->
      line[1..-2].map (pixel, x) ->
        Math.floor (
          image[y    ][x] + image[y    ][x + 1] + image[y    ][x + 2] +
          image[y + 1][x] +        pixel        + image[y + 1][x + 2] +
          image[y + 2][x] + image[y + 2][x + 1] + image[y + 2][x + 2]
        ) / 9


