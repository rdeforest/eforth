_ = require 'underscore'

singletonConstructor = (fn) ->
  theOne = null

  (args...) ->
    if theOne
      return theOne

    theOne = this
    fn.apply this, args

class Town
  constructor: singletonConstructor ->
    for varName in 'camLevel ph'.split ' '
    @camLevel = @photoLevel = 0
    @addCam()
    @addPhoto()

  camUp: ->
    @camLevel++
    @camPower = (@camLevel + 3) / 4

  photoUp: ->
    @photoLevel++
    @photoPower = (@photoLevel + 3) / 4

class Hunie
  constructor: (@name, @traits) ->
    @items = []
    @doing = []
    @minutesLeft = 0
    @skill = @style = 1
    @town = new Town

  styleRate: [1..5].map (n) -> n**2 + n * 4

  skillRate: [1..5].map (n) -> (n + 1) / 4

  sessionPayRate: (style, skill) ->
    2**(style + skill - 2)

  sessionGrossRate: (fans, skill, upgrades) ->
    upgradeFactor = 1
    fans * skillRate[skill] * upgradeFactor

  profitRate: (fans, skill, upgrades, style) ->
    sessionGrossRate(fans, skill, upgrades) - sessionPayRate(style, skill)

_(root).extend Hunie: Hunie
