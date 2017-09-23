# Proxy wrap a regular object and give it Map behavior.
#
# N.B.: This changes the behavior of maps in that keys which are strings which
# already exist in the prototype chain are not stored in the real Map, which
# may lead to surprises.
#
# Also, this version ignores the receiver, meaning inheriting from an instance
# of MapV2 will also lead to surprises. For this reason, 'construct' throws.

class MapV2
  constructor: (iterable) ->
    @map = new Map iterable
    return MapV2.wrap @

  @wrap: (container)
    new Proxy container, MapV2.proxyHandlers

  @proxyHandlers:
    get: (target, prop, receiver) ->
      if target[prop] is undefined
        target.map.get prop
      else
        target[prop]

    set: (target, prop, value, receiver) ->
      if target[prop] is undefined
        target.map.set prop, value
      else
        target[prop] = value

    has: (target, prop, receiver) ->
      (target.map.has prop) or 
      (prop in target)

    construct: ->
      throw new Error "Inheriting from #{@constructor.name} not supported."

    deleteProperty: (target, prop) ->
      if prop in Object.keys target
        delete target[prop]
      else
        target.map.delete prop
