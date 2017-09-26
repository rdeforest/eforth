View = require './view'

module.exports =
  class IndexedView extends View
    constructor: ({@index}) ->
      super

    add: (fact) ->
      super
      @index.apply fact

    find: (query) ->
      @index.get query

