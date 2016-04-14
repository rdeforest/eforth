_ = require 'underscore'
fs = require 'fs'

_(String.prototype).extend
  fillWidth: (width) ->
    if width > 0
      this.repeat(width).substr(0, width)
    else
      ''

  padStart: (width, pad = ' ') ->
    this + (pad.fillWidth width - @length)

  padEnd: (width, pad = ' ') ->
    (pad.fillWidth width - @length) + this

  center: (width, pad = ' ') ->
    diff = width - @length
    middle = Math.floor diff / 2
    [ pad.fillWidth(middle), this, pad.fillWidth(diff - middle)].join ''

fs.readFile 'girls.txt', (err, buffer) ->
  console.log ''
  lines = buffer.toString().split '\n'
  girls = {}
  traits = []

  for info in lines
    [girl, trait...] = info.split ' '
    trait = trait
      .filter (s) -> s.length
      .join ' '

    if trait
      (girls[girl] or= {})[trait] = true
      traits.push trait

  paddedTraits = _(traits).uniq().map (s) -> s.center 11

  console.log ''.padEnd(10) + paddedTraits.join ''

  for girl, girlTraits of girls
    line = girl.padEnd(9) + ': '

    for trait in traits
      if girl[trait]
        line += 'X'.center 11
      else
        line += ''.padEnd 11

    console.log line

