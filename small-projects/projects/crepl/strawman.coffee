# Just the minimum to demonstrate my point and maybe get me started

class PersistenceEngine
  constructor: (@conf = {}) ->

class Store
  constructor: (@engine, @conf) ->


world =
  try
    require 'world'
  catch whoCares
    {}

# o class Foo
# o f = (args) -> ...

persisteMember = (name, o) ->


o = (def) ->
  name = def.name || Symbol

  persistMember name, def

