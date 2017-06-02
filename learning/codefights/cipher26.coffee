module.exports =
  cipher26 = (message) ->
    letters = "abcdefghijklmnopqrstuvwxyz"
    value = (c) -> letters.indexOf c

    soFar = 0

    (for c in message
      soFar += v = ((26**4 + value(c) - soFar) + 52) % 26
      letters[v]
    ).join ''
