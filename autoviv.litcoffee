    inherits = (o, prop) ->
      try
        while o = Object.getPrototypeOf o
          if prop in Object.getOwnPropertyNames o
            return o.constructor.name
      catch
        undefined

    autoviv = (o = {}) ->
      p = new Proxy {},
        ownKeys: (target) ->
          console.log "getOwnPropNames => ", pn = Object.getOwnPropertyNames(o)
          pn
          #  .concat Object.getOwnPropertySymbols(o)

        get: (target, prop, receiver) ->
          v = o[prop]

          vStr =
            try
              JSON.stringify v
            catch e
              try
                v.toString()
              catch e
                "unrepresentable"

          console.log "[%s] %s (%s)", prop.toString(), (
              switch
                when prop is 'inspect'
                  "is 'inspect' which we refuse to override"
                when definer = inherits o, prop
                  "is inherited from #{definer}"
                when prop in Object.getOwnPropertyNames o
                  "is already set"
                when 'symbol' is typeof prop
                  "is a not used symbol"
                else
                  o[prop] = autoviv()
                  "auto-viv"
            ), v

          return o[prop]

    autoviv._knownSyms = []

    for klass in [Symbol, Array]
      for sym in Object.getOwnPropertySymbols klass.prototype
        autoviv[sym.toString()] = sym
        autoviv._knownSyms.push sym

    module.exports = autoviv
