module.exports = info =
  girls:
    Aiko:
      traits: [ 'Asian',      'Glasses'    ]
      skill: 4, style: 2
    Audrey:
      traits: [ 'Flat Chest', 'Teen'       ]
      skill: 2, style: 2
    Beli:
      traits: [ 'Asian',      'Chubby'     ]
      skill: 2, style: 1
    Brooke:
      traits: [ 'Glasses',    'MILF'       ]
      skill: 3, style: 5
    Candace:
      traits: [ 'Fit',        'Huge Tits'  ]
      skill: 5, style: 3
    Jessie:
      traits: [ 'Chubby',     'MILF'       ]
      skill: 5, style: 2
    Kyanna:
      traits: [ 'Latina',     'Thick Ass'  ]
      skill: 1, style: 1
    Lailani:
      traits: [ 'Asian',      'Flat Chest' ]
      skill: 3, style: 1
    Lillian:
      traits: [ 'Tattoos',    'Teen'       ]
      skill: 2, style: 4
    Lola:
      traits: [ 'Ebony',      'Fit'        ]
      skill: 3, style: 3
    Marlena:
      traits: [ 'Huge Tits',  'Latina'     ]
      skill: 5, style: 5
    Nadia:
      traits: [ 'MILF',       'Tattoos'    ]
      skill: 2, style: 2
    Nikki:
      traits: [ 'Glasses',    'Huge Tits'  ]
      skill: 1, style: 1
    Nora:
      traits: [ 'Latina',     'Tattoos'    ]
      skill: 2, style: 5
    Renee:
      traits: [ 'Ebony',      'Thick Ass'  ]
      skill: 4, style: 4
    Sarah:
      traits: [ 'Chubby',     'Thick Ass'  ]
      skill: 1, style: 3
    Tiffany:
      traits: [ 'Fit',        'Teen'       ]
      skill: 1, style: 1
    Zoey:
      traits: [ 'Ebony',      'Flat Chest' ]
      skill: 1, style: 2

info.traits = {}

for name, girl of info.girls
  for trait, idx in girl.traits
    (girl.traits[idx] =
      (info.traits[trait] or= []))
        .push girl

