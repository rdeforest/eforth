module.exports =
  class View
    constructor: ({@journal}) ->
      @lastFactId = -1

    add: (fact) ->
      @lastFactId = fact.id
