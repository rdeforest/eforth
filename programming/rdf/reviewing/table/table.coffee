if 'function' isnt typeof define
  define = require('amdefine')(module)

define ['Cell', 'Row', 'Column'],
       ( Cell ,  Row ,  Column ) ->

	class Table
		constructor: (startData) ->
			@columns = []
			@rows = []

			if startData
				@init startData

    col: (info) ->
      c = info.c
      info.t = this

      if col = @columns[c]
        Object.assign col, info
      else
        @columns[c] = new Row info

    row: (info) ->
      r = info.r
      info.t = this

      if row = @rows[r]
        Object.assign row, info
      else
        @rows[r] = new Row info

		init: (data) ->
			notImplemented =
				new Error "Init from non-list-of-lists not yet implemented"

			if (not Array.isArray data) or
					data.length isnt (data.filter Array.isArray).length
				throw notImplemented

			if data.hasHeaders
				[headers, data...] = data
				@col {name, c} for name, c in headers

			for rowData, r in data
				@addCells rowData.map (v, c) -> {v, r, c}

		addColumn: (info) ->
			info.t = this
			@columns[info.c] = new Column info

		updateColumn: (info) ->
			c = info.c

			col = @columns[c] or= new Column info

			col[k] = v for k, v of info
			col.resize()

		setCell: (info) ->
			info.table = this
			old = @cells[r][c]

			if old
				old[k] = v for k, v of info
			else
				cell = new Cell info
				@cells[r][c] = cell

		addCells: (cells) ->
			@cell cell for cell in cells

    cell: (info) ->
      info.t = this
      {r, c} = cell = new Cell info

      (@row r).cellArriving cell
      (@col c).cellArriving cell

      @cells[r][c] = cell

		toList: ->
		toString: ->


