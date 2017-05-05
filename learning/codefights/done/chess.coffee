module.exports =
  chessBoardCellColor = (cell1, cell2) ->
    x1 = "ABCDEFGH".indexOf cell1[0].toUpperCase()
    x2 = "ABCDEFGH".indexOf cell2[0].toUpperCase()
    y1 = "12345678".indexOf cell1[1]
    y2 = "12345678".indexOf cell2[1]

    return (Math.abs(x1 - x2) % 2) is (Math.abs(y1 - y2) % 2)
