module.exports = (fn) ->
  singleton = null

  (args...) ->
    if singleton
      return singleton

    singleton = this

    fn.apply this, args
