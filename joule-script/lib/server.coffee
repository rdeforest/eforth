class Server
  constructor: (@bindings = {}) ->
    @facets = []

  o: (bindingName, message) ->
    @bindings[bindingName] message
