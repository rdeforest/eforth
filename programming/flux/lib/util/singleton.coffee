module.exports = (klass) ->
  constructed = null

  new Proxy klass,
    construct: (target, args, newTarget) ->
      constructed ||=
        Reflect.construct target, args, newTarget



