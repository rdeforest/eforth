_ = require 'underscore'
formatting = require './formatting'


module.exports = info =
  girls:
    Aiko:    skill: 4, style: 2 traits: [ 'Asian',      'Glasses'    ]
    Lailani: skill: 3, style: 1 traits: [ 'Asian',      'Flat Chest' ]
    Beli:    skill: 2, style: 1 traits: [ 'Asian',      'Chubby'     ]
    Nikki:   skill: 1, style: 1 traits: [ 'Huge Tits',  'Glasses'    ]
    Brooke:  skill: 3, style: 5 traits: [ 'MILF',       'Glasses'    ]
    Zoey:    skill: 1, style: 2 traits: [ 'Ebony',      'Flat Chest' ]
    Audrey:  skill: 2, style: 2 traits: [ 'Teen',       'Flat Chest' ]
    Jessie:  skill: 5, style: 2 traits: [ 'MILF',       'Chubby'     ]
    Sarah:   skill: 1, style: 3 traits: [ 'Thick Ass',  'Chubby'     ]
    Kyanna:  skill: 1, style: 1 traits: [ 'Thick Ass',  'Latina'     ]
    Marlena: skill: 5, style: 5 traits: [ 'Huge Tits',  'Latina'     ]
    Candace: skill: 5, style: 3 traits: [ 'Huge Tits',  'Fit'        ]
    Lola:    skill: 3, style: 3 traits: [ 'Ebony',      'Fit'        ]
    Nadia:   skill: 2, style: 2 traits: [ 'MILF',       'Tattoos'    ]
    Lillian: skill: 2, style: 4 traits: [ 'Teen',       'Tattoos'    ]
    Nora:    skill: 2, style: 5 traits: [ 'Latina',     'Tattoos'    ]
    Renee:   skill: 4, style: 4 traits: [ 'Thick Ass',  'Ebony'      ]
    Tiffany: skill: 1, style: 1 traits: [ 'Teen',       'Fit'        ]

  # Get it?! "Showgirls"?! HAHAHAHA ugh
  showGirls: ->
    traits =
      _(info.girls)
        .map (girl) -> girl.traits
        .flatten()
        .uniq()
    
    paddedTraits =



