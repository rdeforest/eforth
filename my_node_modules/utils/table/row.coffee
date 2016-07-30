if typeof define isnt 'function' then define = require('amdefine')(module)

    class Row
      constructor: (info) ->
        {@table, @r} = info

      cells: -> @table.cells[@r]



