proximity = (a, b) -> (x for x, i in a when b[i] is x).length

indent = (pfx, l) -> l.map (s) -> pfx + s

module.exports = class Terminal
  constructor: (@words) ->
    if not (@words.map((w) -> w.length).reduce (a, b) -> if a is b then a else 0)
      throw new Error 'All words on terminal must be same length'

    @reviewOptions()


  toString: ->
    ( for w in [] # @best()
        "\n  #{w}" + (
          for n, l of @options[w].otherwise
            "\n    #{n}:\n      #{l.join '\n     '}"
        ).join ""
    ).join ""


  reviewOptions: ->
    @considerPicking word for word in @words


  considerPicking: (word) ->
    otherwise = ([] for [0 .. @words[0].length])

    for w in @words when w isnt word
      otherwise[proximity word, w].push w

    @options[word] =
      otherwise: otherwise
