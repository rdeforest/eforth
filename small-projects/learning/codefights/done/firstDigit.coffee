firstDigit = (s) ->
  s .split ''
    .find (c) -> c.match /\d/
