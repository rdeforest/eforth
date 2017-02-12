module.exports =
  class Store
    constructor: (config = {}) ->
      throw new Error "class Store is abstract"

    append: (fact) ->
      throw new Error "class Store is abstract"



