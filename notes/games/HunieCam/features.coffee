# Extends String to add padStart/right, padEnd/left and center
_ = require 'underscore'
fs = require 'fs'

_(String.prototype).extend
  fillWidth: (width) ->
    if width > 0
      this.repeat(width).substr(0, width)
    else
      ''

  padStart: right = (width, pad = ' ') ->
    this + (pad.fillWidth width - @length)

  padEnd: left = (width, pad = ' ') ->
    (pad.fillWidth width - @length) + this

  center: (width, pad = ' ') ->
    diff = width - @length
    middle = Math.floor diff / 2
    [ pad.fillWidth(middle), this, pad.fillWidth(diff - middle)].join ''

_(String.prototype).extend
  left: left
  right: right
