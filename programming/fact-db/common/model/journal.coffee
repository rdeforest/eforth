sleep = (ms) -> new Promise (resolve) -> setTimeout resolve, ms

Fact = require './fact'

module.exports =
  class Journal
    constructor: (config = {}) ->
      { @store = new (require 'stores').default
        @views = []
      } = config

    addView: (View) ->
      @views.push v = new View @
      scanner = @store.getScanner 1, v.lastFactId

      loop
        before = Date.now()
        return if (facts = scanner()).length < 1

        v.add fact for fact in facts
        await sleep Date.now() - before

    add: (document) ->
      id = @store.nextId()
      @store.append new Fact id, document
      @views.forEach (view) -> view.add fact
