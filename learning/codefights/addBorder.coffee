module.exports =
  addBorder = (picture) ->
    topAndBottom = new Array picture[0].length + 2
      .fill '*'
      .join ''

    [topAndBottom]
      .concat picture.map (row) -> "*#{row}*"
      .concat topAndBottom

