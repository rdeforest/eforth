count = (word, letter) ->
  (x for x in word when x is letter).length

module.exports = stringsConstruction = (word, letters) ->
  counts =
    word
      .split ''
      .map (c) ->
        Math.floor count(letters, c) / count(word, c)

  Math.min counts...
