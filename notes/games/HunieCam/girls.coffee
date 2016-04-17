_ = require 'underscore'
require './formatting' # extends String

module.exports = info =
  girls: {}
  traits: {}
  install: ->
    _.extend root,
      info.girls
      info.traits
      info.utils
      __: _

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

class Girl
  constructor: ({@name, @skill, @style, @traits}) ->
    realMe = this

    {girls, traits} = info

    if girls[@name]
      realMe = girls[@name]
    else
      girls[@name] = this

    console.log @traits
    @traits = @traits.map (name) -> new Trait name, realMe
  
  pals: -> _.without (_.flatten _.pluck @traits, 'girls'), this

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


girlData =
  Beli:    name: 'Beli',    skill: 2, style: 1, traits: [ 'Asian',      'Chubby'     ]
  Aiko:    name: 'Aiko',    skill: 4, style: 2, traits: [ 'Asian',      'Glasses'    ]
  Lailani: name: 'Lailani', skill: 3, style: 1, traits: [ 'Asian',      'Flat Chest' ]
  Audrey:  name: 'Audrey',  skill: 2, style: 2, traits: [ 'Teen',       'Flat Chest' ]
  Lillian: name: 'Lillian', skill: 2, style: 4, traits: [ 'Teen',       'Tattoos'    ]
  Tiffany: name: 'Tiffany', skill: 1, style: 1, traits: [ 'Teen',       'Fit'        ]

  Jessie:  name: 'Jessie',  skill: 5, style: 2, traits: [ 'MILF',       'Chubby'     ]
  Sarah:   name: 'Sarah',   skill: 1, style: 3, traits: [ 'Thick Ass',  'Chubby'     ]
  Nikki:   name: 'Nikki',   skill: 1, style: 1, traits: [ 'Huge Tits',  'Glasses'    ]
  Brooke:  name: 'Brooke',  skill: 3, style: 5, traits: [ 'MILF',       'Glasses'    ]
  Zoey:    name: 'Zoey',    skill: 1, style: 2, traits: [ 'Ebony',      'Flat Chest' ]
  Nadia:   name: 'Nadia',   skill: 2, style: 2, traits: [ 'MILF',       'Tattoos'    ]
  Nora:    name: 'Nora',    skill: 2, style: 5, traits: [ 'Latina',     'Tattoos'    ]
  Candace: name: 'Candace', skill: 5, style: 3, traits: [ 'Huge Tits',  'Fit'        ]
  Lola:    name: 'Lola',    skill: 3, style: 3, traits: [ 'Ebony',      'Fit'        ]

  Kyanna:  name: 'Kyanna',  skill: 1, style: 1, traits: [ 'Thick Ass',  'Latina'     ]
  Marlena: name: 'Marlena', skill: 5, style: 5, traits: [ 'Huge Tits',  'Latina'     ]
  Renee:   name: 'Renee',   skill: 4, style: 4, traits: [ 'Ebony',      'Thick Ass'  ]

for name, girl of girlData
  console.log girl
  new Girl girl

_.extend info,
  Girl: Girl
  utils:
    palsOf: (pals) ->
      {girls, traits} = info

      if not pals.length
        pals = [pals]

      morePals = []
      morePals.toList = ->
        @map (chain) ->
          steps = []

          while chain.because
            steps.concat [chain.because.trait, chain.name]
            chain = chain.because
          
          steps.push chain.name
          steps.join ' -> '

      for pal in pals
        for trait in pal.traits
          for name, girl of traits[trait]
            (girl.because = pal).trait = trait
            morePals.push girl

      return morePals

_.extend info.utils,
    pickPosition: pickPosition = (x, y, cell) ->
      ( if x or not y
          cell.center
        else
          cell.left
      ).bind cell

    showTable: showTable = (gen, show = console.log) ->
      table = []
      widths = []

      gen (cells) -> table.push cells.map (c) -> c.toString()

      for row, y in table
        for cell, x in row
          widths[x] = _.max [widths[x] or 0, cell.length]

      show table
        .map (row, y) ->
          row.map (cell, x) -> pickPosition x, y, cell
             .map (position) -> position widths[x]
             .join ''

    logLines: logLines = (lines) -> console.log line for line in lines
    logTable: logTable = (gen) -> showTable gen, logLines

    girlsVsGirls: girlsVsGirls = (receiveRow) ->

    girlsVsTraits: girlsVsTraits = (receiveRow) ->
      traits =
        _(girls)
          .map     ((girl) -> girl.traits)
          .flatten()
          .uniq()
          .sort()
      
      receiveRow ['', traits...].map (trait) -> trait.center 11

      for girlName, info of girls
        receiveRow [
          girlName
          (traits.map (t) -> t in girl.traits)...
        ]


###

addFn = (name, fn) ->
  info[name]

###
