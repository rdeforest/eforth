    module.exports = (opts) ->
      ###
      newElementsOf: (l) ->
        fn =
          if 'function' is typeof l
            l
          else
            -> l

        l = fn()
        seen = 0

        loop
          l = fn()
          len = l.length
          yield l[seen..]
          seen = len
      ###

      announce: announce = (promise, description = "some promise") ->
        console.log "Started #{description}; will announce completion"
        summarize = (v) ->
          util.inspect v

        promise
          .then (result) ->
            console.log "\n\n\n#{description} finished. Result was:\n",
                        summarize result
            result

          .catch (error) ->
            console.log "\n\n\n#{description} failed. Error was:\n",
                        summarize error
            promise

      descriptor: descriptor = Object.getOwnPropertyDescriptor

      proto: proto = Object.getPrototypeOf

      ctor: ctor = (o) -> o.constructor

      props: props = (o) -> Object.getOwnPropertyNames(o).sort()

      syms: syms = Object.getOwnPropertySymbols

      merged: merged = (os...) -> Object.assign {}, os...

      pairsToDict: pairsToDict = (pairs) ->
        Object.assign {},
          ((o = {})[k] = v for [k, v] in pairs)...

      descriptors: descriptors = (o) ->
        pairsToDict (props(o).map (name) ->
          [name, descriptor o, name])...

      definers: definers = (o) ->
        o while o = proto o

      parents: parents = (o) ->
        definers(o).map ctor

      allProps: allProps = (o) ->
        (props o).concat (props o for o in parents o)

      propDefiners: propDefiners = (o) ->
        for d in [o].concat definers o
          pd = {}
          pd[ctor(d).name] = props d
          pd

      globalNames: globalNames = (o) ->
        k for k in props global when global[k] is o


      withList: (list, fn, catchWith = (err) -> throw err) ->
        serialize = Promise.resolve()

        for el, idx in list
          ((el, idx) ->
            serialize = serialize
              .then  (ret) ->        fn      el, idx, ret
              .catch (err) -> catchWith err, el, idx
          ) el, idx

        serialize

      withPages: (service, method, params, fn, catchWith = (err) -> throw err) ->
        thenWith = (data) ->
          fn data

          if data.IsTruncated
            params.Marker = data.Marker
            withPages service, method, params, fn, catchWith

        service[method] params
          .promise()
          .then   thenWith
          .catch catchWith

      deepCopy: (victim, os...) ->
        if not os.length
          if Array.isArray victim
            return deepCopy [], victim
          else
            return deepCopy {}, victim

        for o in os
          if Array.isArray o
            for el, i in o
              victim[i] = deepCopy el
          else
            for k, v of o
              victim[k] = deepCopy v

        return victim

