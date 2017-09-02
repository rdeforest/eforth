addEither = (which) ->
  whichs     = which + "s"
  Which      = which[0].toUpperCase + which[1..]

  firstWhich = "first" + Which
  lastWhich  = "last"  + Which

  (title, idx = @[whichs].length) ->
    if @[firstWhich] is null
      @[firstWhich] =
      @[lastWhich]  = idx
    else
      @[firstWhich] = Math.min @[firstWhich], idx
      @[lastWhich]  = Math.min @[ lastWhich], idx

    @[whichs][idx] =
      title: title
      cells: new Set

module.exports = class Table
  constructor: ->
    @firstRow    =
    @lastRow     =
    @firstColumn =
    @lastColumn  = null

    @columns     = []
    @row         = []
    @cells       = new Set

  addRow   : addEither 'row'
  addColumn: addEither 'column'

  clearCells: (x1, y1, x2, y2) ->
    for cell in @cells
      if  ( x1 <= cell.x1 <= x2  or
            x1 <= cell.x2 <= x2) and
          ( y1 <= cell.y1 <= y2  or
            y1 <= cell.y2 <= y2)

        for axis in Array.from(cell.rows).concat Array.from(cell.columns)
          axis.cells.delete cell

        @cells.delete cell

  setCells: (x1, y1, x2, y2, contents) ->
    @clearCells x1, y1, x2, y2

    @cells.add = cell = {x1, y1, x2, y2, contents}

    (@addColumn '') while x1 > @columns.length
    (@addRow    '') while y1 >    @rows.length

    for x in [x1..x2]
      (@columns[x] ? addColumn("", x))
        .cells
        .add cell

    for y in [y1..y2]
      (@rows[y] ? addRow("", y))
        .cells
        .add cell

    cell.columns = new Set @columns[x1..x2]
    cell.rows    = new Set @rows   [y1..y2]

  toGrid: (x1, y1, x2, y2) ->
    return "" unless @firstRow

    body =
      @rows[@firstRow..@lastRow]
        .map (row, rowIdx) ->

