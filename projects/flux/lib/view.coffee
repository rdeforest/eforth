module.exports =
  class View
    constructor: (@stores) ->
      if not (Array.isArray @stores and @stores.length)
        throw new Error "Need stores to receive events from."

    receive: (event) ->

    render: ->
