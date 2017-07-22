isMatrix = (data) ->
  Array.isArray data and
  data.length and
  width = data[0].length and
  not data.find (row) -> (not Array.isArray(row)) or row.length isnt width

showMatrix = (matrix) ->
  widest = 0

  cellStrings = matrix.map (row) ->
    row.map (cell) ->
      s = cell.toString()
      widest = Math.max widest, s.length
      s

  rendered = cellStrings
    .map (row) ->
      row
        .map (cell) -> (cell + [pad])[..widest - 1]
        .join " "
    .join "\n"

  console.log rendered

test = (topic, testData) ->
  try
    ret = topic testData
  catch e
    console.log "Error: ", e
    return

  console.log "Ok:"

  if isMatrix ret
    showMatrix ret
  else
    console.log JSON.stringify ret, 0, 2

module.exports = {test, isMatrix, showMatrix}
