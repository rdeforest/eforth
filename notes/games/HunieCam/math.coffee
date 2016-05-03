_ = require 'underscore'

{unique, memoize, singleton} = require './singleton'
require './formatting' # extends String

{gameGirls, gameItems, gameResources} = require './game-data'


class Building
  constructor: (@maxTime = 4 * 60) ->
    @uses = 0
    @town = new Town

  nextUseOutput: (girl) ->
    output = {}

    for name, resource in resourceNames
      if 'function' is typeof this[fName = 'nextUse' + name]
        output[resource.name] = this[fname] girl

  nextUseTime: -> _.min [@maxTime, (Math.ceil(@uses / 2) + 1) * 15]

  use: (girl) -> @uses++

  click: -> # virtual method, but it's OK to not override it


class TrainingBuilding extends Building
  constructor: (@skill) ->
    super undefined, 8

  # Depends on girl's skill/style, don't know formula yet
  nextUseTime: (girl) -> girl.attr[@skill].

  click: (girl) ->
    girl.attr[@skill].addPoints @town.gatherRate[@skill]


class ResourceBuilding extends Building
  constructor: (maxTime) ->
    super undefined, maxTime


class CamBuilding extends ResourceBuilding
  constructor: ->
    super 12

  nextUseOutput: (girl) ->
    _.extend super girl,
      money: girl.camGross()
      fans: girl.camFans()


class PhotoBuilding extends ResourceBuilding
  constructor: ->
    super 8

  nextUseOutput: (girl) ->
    _.extend super girl,
      fans: girl.photoFans()


# There can be only one town, obviously.
class Town
  constructor: singleton ->
    @cam = new CamBuilding
    @photo = new PhotoBuilding
    @hardMode = false
    @girls = []
    @worldClock = 0 # minutes

  rockHard: @hardMode and 3 or 1

  promoRates: -> # will return $ / fan


class Trait
  constructor: memoize (@name) ->
    Trait.traits[@name] = this

    @girls = []
    @items = []
    @fans = 0

  # XXX: WELL NOW HERE'S A CODE SMELL
  addGirl: (girl) -> @girls = _.union @girls, [girl]
  addItem: (item) -> @items = _.union @items, [item]


class HunieItem
  constructor: (@name, info = HunieItem.gameItems[@name]) ->
    _.extend this, info

class HunieJob
  constructor: (@name, @building) ->


class HunieTask
  constructor: (@job, @girl) ->


class HunieAttr
  constructor: -> @points = 0

  level: ->
    switch Math.floor @points / 25
      when  0 then 1
      when  1 then 2
      when  3 then 3
      when  6 then 4
      when 10 then 5

  addPoints: (points) -> @points += points


class Style
  fanGainMult: @level * (@level + 4)


class Skill
  payMult: -> (@level + 1) / 4


class Hunie
  constructor: (@name, info = Hunie.gameGirls[@name]) ->
    {@traits, skill, style} = info
    @attr = _.extend {}, @startAttr =
      skill: new Skill skill
      style: new Style style
    @items = []
    @doing = null
    @town = new Town
    @time = 0

  allTraits: ->
    @traits.concat _.pluck @items, 'trait'

  fans: -> Math.sum _.pluck @allTraits(), 'fans'
    
  itemEffect: (n, valueName) ->
    n = item[valueName] n for item in @items when item[valueName]

  townEffect: (n, valueName) ->
    n * switch valueName
      when 'income' then @town.cam.pow
      when 'fans'   then @town.photo.pow
      else 1
    
  combinedEffect: (n, valueName) ->
    @townEffect (@itemEffect n, valueName), valueName

  adjustSession: (n) -> @combinedEffect(n, 'income') * Town.rockHard()
  adjustFans:    (n) -> @combinedEffect(n, 'fans')

  sessionPayRate: -> 2 ** @level()
  fansPerShoot:   -> fans * @adjustFans    @style.fanGainMult()
  sessionValue:   -> fans * @adjustSession @skill.payMult()

  itemGet:  (item) ->
    @items.push item
    item.girls.push this

  itemLost: (item) ->
    @items = _(@items).without item
    item.girls = _(item.girls).without this

  level: -> @skill + @style - 2


  camGross: ->
    @fans * @skillRate() * @town.cam.power

  camNet: ->
    (@camGross()) - (@camPay(@town.cam.nextUseTime()))

_(root).extend
  Hunie: Hunie
  Town: Town
