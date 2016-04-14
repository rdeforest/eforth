_ = require 'underscore'

singletonConstructor = (fn) ->
  theOne = null

  (args...) ->
    if theOne
      return theOne

    theOne = this
    fn.apply this, args


class Building
  constructor: (@startTime = 0.25, @maxTime = 4) ->
    @uses = 0

  nextUseTime: (girl) -> _.min [@maxTime, (@uses + 1) / 4]

  use: (girl) -> @uses++


class TrainingBuilding extends Building
  constructor: (@skill) ->
    super undefined, 8

  nextUseTime: (girl) ->

  use: (girl) -> girl[skill]++


class ResourceBuilding extends Building
  constructor: (maxTime) ->
    super undefined, maxTime

  nextUse: (girl) ->
    timeCost: @nextUseTime girl


class CamBuilding extends ResourceBuilding
  constructor: ->
    super 12

  nextUse: (girl) ->
    _.extend super girl,
      money: girl.camGross()
      fans: girl.camFans()


class PhotoBuilding extends ResourceBuilding
  constructor: ->
    super 8

  nextUse: (girl) ->
    _.extend super girl,
      fans: girl.photoFans()


class Town
  constructor: singletonConstructor ->
    @cam = new CamBuilding
    @photo = new PhotoBuilding


class Hunie
  constructor: (@name, info) ->
    {@traits, @skill, @style} = info
    @items = []
    @doing = []
    @minutesLeft = 0
    @skill = @style = 1
    @town = new Town
    @time = 0

  adjustIncome: (n) ->
    fns = []

    for item in @items
      if item.adjustIncome
        n = item.adjustIncome n, this

  itemGet:  (item) -> @items.push item

  itemLost: (item) -> @items = _(@items).without item

  level: -> @skill + @style - 2

  fansPerShoot: ->
    @style ** 2 + @style * 4

  skillRate: ->
    @adjustFans
    [1..5].map (n) -> (n + 1) / 4

  sessionPayRate: ->
    @adjustIncome 2 ** @level()) * pigFactor

  camGross: ->
    @fans * @skillRate() * @town.cam.power

  camNet: ->
    (@camGross()) - (@camPay(@town.cam.nextUseTime()))

_(root).extend
  Hunie: Hunie
  Town: Town
