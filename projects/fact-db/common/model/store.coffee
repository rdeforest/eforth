module.exports =
  class Store
    constructor: (config = {}) ->
      @dbTop = 0

    append: (fact) ->

    getScanner: (batchSize, lastScanned = 0) ->

    nextId: -> @dbTop
