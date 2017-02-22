cs = require 'coffee-script'

class BuildingType
  constructor: (@name, opts) ->
    { @buildCost          = 0
      @levelScalarPercent = 25
      @maxHeat            = Infinity
      @firstUpgradeCost   = Infinity
    } = opts

    return BuildingType.types[@name] ?= @

  @types: {}



multiplier = (k) -> (n) -> n * k
pow10 = (n) -> 10 ** n

Object.assign global, {cs, multiplier, pow10, BuildingType}

for pow, i in 'thousand million buillion trillion quadrillion'.split ' '
  cs.eval "global.#{pow} = multiplier pow10 #{(i+1)*3}"

new BuildingType 'boilerHouse',
  buildCost:          million 15
  levelScalarPercent:         40
  firstUpgradeCost:   million 50

