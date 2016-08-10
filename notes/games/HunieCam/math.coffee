{without, min, pluck, union} = require 'underscore'

require './formatting' # extends String

{gameGirls, gameItems, gameResources} = require './game-data'


ignore: ->
# There can be only one town, obviously.
  class Town
    constructor: ->
      if Town.singleton
        return Town.singleton
      Town.singleton = this
      @cam = new CamBuilding
      @photo = new PhotoBuilding
      @hardMode = false
      @girls = []
      @worldClock = 0 # minutes

    rockHard: @hardMode and 3 or 1

    promoRates: -> # will return $ / fan


class HunieItem
  constructor: (@name, info = HunieItem.gameItems[@name]) ->
    Object.assign this, info

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
    @attr = Object.assign {}, @startAttr =
      skill: new Skill skill
      style: new Style style
    @items = []
    @doing = null
    @town = new Town
    @time = 0

  allTraits: ->
    @traits.concat pluck @items, 'trait'

  fans: -> Math.sum pluck @allTraits(), 'fans'
    
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
    @items     = without @items     item
    item.girls = without item.girls this

  level: -> @skill + @style - 2


  camGross: ->
    @fans * @skillRate() * @town.cam.power

  camNet: ->
    (@camGross()) - (@camPay(@town.cam.nextUseTime()))

Object.assign global,
  Hunie: Hunie
  Town: Town
