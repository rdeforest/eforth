prototypeChain = (o) -> [Object.getPrototypeOf o].concat (o while o = o.constructor.__super__)

bindMethods = (o) ->
  prototypeChain o
    .forEach (proto) ->
      #console.log "Examining #{className = proto.constructor.name}"
      Object.getOwnPropertyNames proto
        .filter  (methodName) ->
          if 'function' is typeof proto[methodName]
            true
          #else
          #  console.log "ignoring #{className}::#{methodName}"

        .forEach (methodName) ->
          return if methodName in Object.getOwnPropertyNames o
          #console.log "binding #{className}::#{methodName}"
          o[methodName] = proto[methodName].bind o

bound = Symbol()

bindMethods = (o) ->
  o[bound] ?= new Map

  for proto in prototypeChain o
    for methodName in Object.getOwnPropertyNames proto when 'function' is typeof fn = proto[methodName]
      if not bindings = o[bound].get proto
        o[bound].set proto, bindings = {}

      bindings[methodName] = bound = fn.bind o
      Object.defineProperty o, methodName,
        value        : bound
        enumerable   : false
        configurable : true
        writable     : true

class Binder
  constructor: ->
    @[bound] = bindings = new Map

    for proto in prototypeChain @
      bindings.set proto, {}

Object.assign module.exports, {bindMethods}
