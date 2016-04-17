_ = require 'underscore'

_.extend String.prototype,
  left: (w) ->
    if w < @length
      return this.toString()
    else
      this + ' '.repeat @length - w

  right: (w) ->
    if w < @length
      return this.toString()
    else
      ' '.repeat(@length - w) + this

  center: (w) -> @left(w / 2).right w
