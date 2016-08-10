Backbone = require 'backbone'

Girls = Backbone.Collection.extend
  model: Girl

Girl = Backbone.Model.extend
  genes: [] # innate Traits
  items:  []
  followers: {} # traits + items
  clock: require 'clock'

  addItem: (item) ->

  startTask: (building) ->

###

  initialize: ({@name, @skill, @style, @traits}) ->
    realMe = this

    {girls, traits} = info

    if girls[@name]
      realMe = girls[@name]
    else
      girls[@name] = this

    console.log @traits
    @traits = @traits.map (name) -> new Trait name, realMe
    @items = []

  fans: ->
    @traits[0].fans() + @traits[1].fans()

  followers: ->
    total = @fans()

    for toy in @items
      if toy.trait
        total += info.fans[toy.trait]

    total

  pals: -> _.without (_.flatten _.pluck @traits, 'girls'), this

  level: -> @skill + @style - 2

  cost: -> 2 ** @level()

  pathsTo: (dest, seen = [this]) ->
    paths = []

    for girl in @pals() when not (girl in seen)
      if girl is dest
        paths.push [this, dest]
      else
        console.log "Looking for #{dest.name} through #{girl.name} without searching #{_.pluck seen, 'name'}"

        for pathFound in girl.pathsTo dest, [this, seen...]
          paths.concat [this].concat pathFound

    return paths

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


###
