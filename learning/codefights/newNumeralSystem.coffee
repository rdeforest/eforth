module.exports =
  newNumeralSystem = (number) ->
    digits = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

    b = value = digits.indexOf number

    for a in [0..Math.floor value / 2]
      digits[a] + " + " + digits[b--]
