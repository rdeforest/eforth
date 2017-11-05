Backbone = require 'backbone'
_        = require 'underscore'

Girls = Backbone.Collection.extend
  model: Girl

gd = require '../game-data'

pointsToLevel = (points) ->
  levels = [-Infinity, 0, 25, 75, 150, 250, Infinity]

  1 + levels.findIndex (required) -> points < required

Girl = Backbone.Model.extend
  initialize: (town, name) ->
    {style, skill} = gd.girl name

    @set stylePoints: pointsToLevel style
    @set skillPoints: pointsToLevel skill

    @set {town, name}

  genes     : ->
    gd.girl @name
      .traits

  items     : []
  stylePts  : 0
  skillPts  : 0

  # derived values
  style     : -> pointsToLevel @style
  skill     : -> pointsToLevel @skill

  level     : -> @skill() + @style() - 2

  traits    : -> @genes.concat _.pluck items, 'trait'
  fans      : -> _.sum @traits().map (t) -> @town.traitFans(t)

  wage      : -> @town.wageAtLevel @level
  camDraw   : -> @town.camDraw     @fans
  photoDraw : -> @town.photoDraw   @style

  # mutators
  addItem   : (item) -> @set items: @get('items').concat item
  delItem   : (item) -> @set items: @get('items').filter (i) -> i isnt item

  addStyle  : -> @set style: @get('style') + 1
  addSkill  : -> @set skill: @get('skill') + 1

