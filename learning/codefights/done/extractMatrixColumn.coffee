module.exports =
  extractMatrixColumn = (matrix, column) ->
    matrix.map (row) -> row[column]
