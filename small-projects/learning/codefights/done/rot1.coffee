module.exports =
  alphabeticShift = (s) ->
    a = 'a'.charCodeAt 0
    z = 'z'.charCodeAt 0
    A = 'A'.charCodeAt 0
    Z = 'Z'.charCodeAt 0

    isLetter = (c) -> a <= c <= z or A <= c <= Z

    rot1 = (c) ->
      d = c.charCodeAt(0)

      # sometimes side effects can be beautiful
      String.fromCharCode(if isLetter(d++) and not isLetter(d) then d - 26 else d)

    s.split('').map(rot1).join('')

