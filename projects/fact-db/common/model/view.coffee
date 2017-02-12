module.exports =
  class View
    constructor: ({@journal}) ->
      throw new Error "class View is abstract"

    add: (fact) ->
      throw new Error "class View is abstract"

