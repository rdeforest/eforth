Table formatting like 'column -t'

  t = new Table [["a","b"], ["x","y"]]
  => Table { columns: [ {width: 1}, {width: 1} ], rows: [ [{v: "a"},...

  t.toString()
  => "a b\nx y"

  t.toList()
  => ["a b", "x y"]

    if 'function' isnt typeof define
      define = require('amdefine')(module)

    define ['Table', 'Column', 'Row', 'Cell'],
           ( Table ,  Column ,  Row ,  Cell ) ->

    module.exports =
           { Table ,  Column ,  Row ,  Cell }
