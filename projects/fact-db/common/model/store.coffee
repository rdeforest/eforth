module.exports =
  class Store
    constructor: (config = {}) ->
      throw new Error "class Store is abstract"

    append: (fact) ->
      throw new Error "class Store is abstract"

    getScanner: (n) ->
      n = 1 unless 'number' is typeof n and n > 1
      n = Math.floor n
      cursor = 0

      scanner = ->
        if cursor.length is @facts.length
          []
        else
          [@facts[cursor..(cursor+=n) - 1]]



