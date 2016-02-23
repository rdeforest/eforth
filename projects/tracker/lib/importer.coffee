csv = require 'csv'

currentSheet = null
workbook =
  sheet: {}

currentColumn = 1
currentRow = 1

columnNames = 1: 'A'

makeColumn = (num( ->
  name = ''

  while num > 26
    digit = String.fromCharCode (num % 26 + 1)
    name = digit + name
    num /= 26

  name

columnName = (num) -> columnNames[num] ||= makeColumn num

newSheet = (name, reversed) ->
  workbook.sheet[name] =
    currentSheet =
      cells: {}
      reversed: reversed

newColumn = (from, to) ->
  currentRow = 1
  currentColumn++

  addData 0, from + " to " + to

addData = (time, value) ->
  

process.stdin
  .pipe csv.parse()
  .pipe csv.transform (record) ->
    [id, value_a, value_b] = record
    switch id
      when "group"  then newSheet  value_a, value_b
      when "scale"  then newColumn value_a, value_b
      when "result" then addData   value_a, value_b
      else throw new Error "Unknown record type #{id}"

