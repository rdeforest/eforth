_ = require 'underscore'
singletonConstructor = require './singleton'

class Building
  constructor: (@maxHours) ->
    @level = 1
    @uses = 0

  hours: -> (@uses + 1) * 0.25

  use: -> @uses++

  upgrade: -> @level++

  power: -> (@level + 3) / 4

class Town
  constructor: singletonConstructor ->
    @camStudio   = new Building 12
    @photoStudio = new Building 8
    @adultShop   = new Building 8
    @boutique    = new Building 4
    @stripClub   = new Building 4

class Hunie
  constructor: (@name, info) ->
    
    @items = []
    @doing = []
    @minutesLeft = 0
    @skill = @style = 1
    @town = new Town

  styleRate: [1..5].map (n) -> n**2 + n * 4

  skillRate: [1..5].map (n) -> (n + 1) / 4

  payRate: -> 2 ** (@style + @skill - 2)

  camSesGross: -> fans * skillRate[skill] * @town.camPower
  camSesCost: -> @payRate() * @town.

  profitRate: (fans, skill, upgrades, style) ->
    sessionGrossRate(fans, skill, upgrades) - sessionPayRate(style, skill)

girls = {}

for name, info of require './girls'
  girls[name] = new Hunie name, info

_(root).extend Hunie: Hunie, Town: Town, town: new Town

