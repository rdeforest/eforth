if typeof define isnt 'function' then define = require('amdefine')(module)

define [],
       () ->

  class Column
    constructor: (info) ->
      { @table
        @width = 0
        @c
        @name = Column.defaultName @c
      } = info

    cells: ->
      @table
        .cells[r]
        .map (r) -> r[@c]
        .filter (c) -> c

    resize: ->
      @width =
        @cells
          .map (c) -> c.width()
          .reduce Math.max

  Column.defaultName = (colNum) ->
    if colNum < 0
      throw new Error "Column index '#{colNum}' < 0"

    name = ""

    while colNum
      name = String.fromCharCode(mod = colNum % 26) + name
      colNum = (colNum - mod) / 26

    name



