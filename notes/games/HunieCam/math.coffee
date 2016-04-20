_ = require 'underscore'

{unique, memoize, singleton} = require './singleton'
require './formatting' # extends String

class Building
  constructor: (@startTime = 0.25, @maxTime = 4) ->
    @uses = 0

  nextUseOutput: (girl) ->
    time: @nextUseTime girl

  nextUseTime: (girl) -> _.min [@maxTime, (@uses + 1) / 4]

  use: (girl) -> @uses++


class TrainingBuilding extends Building
  constructor: (@skill) ->
    super undefined, 8

  # Depends on girl's skill/style, don't know formula yet
  #nextUseTime: (girl) ->

  use: (girl) ->
    girl[@skill]++


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


# There is only one town, obviously.
class Town
  constructor: singleton ->
    @cam = new CamBuilding
    @photo = new PhotoBuilding
    @hardMode = false
    @girls = []

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

HunieItem.gameItems =
  pig:      income:   (income)     -> n / 2
  coke:     duration: (time, task) -> time / 2
  shoes:    duration: (time, task) -> task is 'dance' and time / 2 or time
  magazine: duration: (time, task) -> task is 'shop' and time / 2 or time
  basket:   haul:     (count)      -> count * 2

class HunieJob
  constructor: (@name, @building) ->

_.extend Hunie,
  gameGirls:
    # lvl = 0
    Tiffany: name: 'Tiffany', skill: 1, style: 1, traits: [ 'Teen',       'Fit'        ]
    Nikki:   name: 'Nikki',   skill: 1, style: 1, traits: [ 'Huge_Tits',  'Glasses'    ]
    Kyanna:  name: 'Kyanna',  skill: 1, style: 1, traits: [ 'Thick_Ass',  'Latina'     ]

    # lvl = 1
    Beli:    name: 'Beli',    skill: 2, style: 1, traits: [ 'Asian',      'Chubby'     ]
    Zoey:    name: 'Zoey',    skill: 1, style: 2, traits: [ 'Ebony',      'Flat_Chest' ]

    # lvl = 2
    Lailani: name: 'Lailani', skill: 3, style: 1, traits: [ 'Asian',      'Flat_Chest' ]
    Audrey:  name: 'Audrey',  skill: 2, style: 2, traits: [ 'Teen',       'Flat_Chest' ]
    Sarah:   name: 'Sarah',   skill: 1, style: 3, traits: [ 'Thick_Ass',  'Chubby'     ]

    Nadia:   name: 'Nadia',   skill: 2, style: 2, traits: [ 'MILF',       'Tattoos'    ]

    # lvl = 4
    Aiko:    name: 'Aiko',    skill: 4, style: 2, traits: [ 'Asian',      'Glasses'    ]
    Lola:    name: 'Lola',    skill: 3, style: 3, traits: [ 'Ebony',      'Fit'        ]
    Lillian: name: 'Lillian', skill: 2, style: 4, traits: [ 'Teen',       'Tattoos'    ]

    # lvl = 5
    Jessie:  name: 'Jessie',  skill: 5, style: 2, traits: [ 'MILF',       'Chubby'     ]
    Nora:    name: 'Nora',    skill: 2, style: 5, traits: [ 'Latina',     'Tattoos'    ]

    # lvl = 6
    Candace: name: 'Candace', skill: 5, style: 3, traits: [ 'Huge_Tits',  'Fit'        ]
    Renee:   name: 'Renee',   skill: 4, style: 4, traits: [ 'Ebony',      'Thick_Ass'  ]
    Brooke:  name: 'Brooke',  skill: 3, style: 5, traits: [ 'MILF',       'Glasses'    ]

    # lvl = 8
    Marlena: name: 'Marlena', skill: 5, style: 5, traits: [ 'Huge_Tits',  'Latina'     ]


class Style
  constructor: (@level = 1) ->

  fanGainMult: @level * (@level + 4)

class Skill
  constructor: (@level = 1) ->
  
  payMult: -> (@level + 1) / 4

class Hunie
  constructor: (@name, info = Hunie.gameGirls[@name]) ->
    {@traits, skill, style} = info
    @attr = _.extend {}, @startAttr =
      skill: new Skill skill
      style: new Skill style
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
