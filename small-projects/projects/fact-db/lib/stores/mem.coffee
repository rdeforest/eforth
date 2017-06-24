Store = require 'common/model/store'

module.exports =
  class MemStore extends Store
    constructor: (config = {}) ->
      @facts = []

    append: (fact) ->
      @facts.push fact

    fact: (id) -> @facts[id]

