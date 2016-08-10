class Trait
  constructor: (@name) ->
    if Trait.traits[@name]
      return Trait.traits[@name]

    Trait.traits[@name] = this

    @girls = []
    @items = []
    @fans = 0

  # XXX: WELL NOW HERE'S A CODE SMELL
  # Too bad ES6 Iterators and CoffeeScript don't play well together yet
  addGirl: (girl) -> @girls = union @girls, [girl]
  addItem: (item) -> @items = union @items, [item]


ignore: ->
  class Trait
    constructor: (@name, girl) ->
      realMe = this # "Can you see the real me? Can ya? Can ya?

      {traits} = info

      @girls = []

      if traits[@name]
        realMe = traits[@name]
      else
        traits[@name] = this

      if girl
        realMe.addGirl girl

      return realMe

    addGirl: (girl) -> @girls = _.union @girls, [girl]

    fans: -> info.fans[@name]

