module.exports =
  areIsomorphic = (a, b) ->
    a.length is b.length and
      -1 is a.findIndex (row, ridx) ->
        row.length isnt b[ridx].length
