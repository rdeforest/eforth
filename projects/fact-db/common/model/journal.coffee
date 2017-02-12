module.exports =
  class Journal
    constructor: (config = {}) ->
      {
        @store = new (require 'stores').default
        @views = []
      } = config

    addView: (View) ->
      @views.push new View journal: @

    add: (fact) ->
      @store.append fact
      @views.forEach (view) -> view.add fact
