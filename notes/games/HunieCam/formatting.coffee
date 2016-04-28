_ = require 'underscore'

_.extend String.prototype,
  left: (w) ->
    if w < @length
      return this.toString()
    else
      this + ' '.repeat(w - @length)

  right: (w) ->
    if w < @length
      return this.toString()
    else
      ' '.repeat(w - @length) + this

  center: (w) -> @left(w / 2).right w
