module.exports =
  stolenLunch = (note) ->
    letters = "abcdefghij"
    digits  = "0123456789"

    ( for c in note
        if c in letters
          String.fromCharCode c.charCodeAt(0) - 49
        else if c in digits
          String.fromCharCode c.charCodeAt(0) + 49
        else
          c
    ).join ''
