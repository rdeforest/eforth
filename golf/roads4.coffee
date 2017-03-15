# https://codefights.com/arcade/graphs-arcade/kingdom-roads/wkhfpfiT6YynLk2qE

listMinusMember = (l, i) -> l.filter (e, j) -> j isnt i

tableMinusColumnAndRow = (table, i) ->
  listMinusMember table, i
    .map (row) -> listMinusMember row, i

financialCrisis = (roadRegister) ->
  roadRegister.map (r, i) ->
    tableMinusColumnAndRow roadRegister, i

register = [[false, true,  true,  false],
            [true,  false, true,  false],
            [true,  true,  false, true ],
            [false, false, true,  false]]

Object.assign global, {tableMinusColumnAndRow, financialCrisis, register}
