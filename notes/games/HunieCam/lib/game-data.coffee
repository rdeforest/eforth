module.exports =
  gameResources:
    Time:     name: 'time',  unit: 'minute'
    Money:    name: 'money'  unit: 'dollar'
    Skill:    name: 'skill'  unit: 'note'
    Style:    name: 'style'  unit: 'bow'
    Fans:     name: 'fans'   unit: 'fan'

  gameItems:
    pig:      income:   (income)     -> n / 2
    coke:     duration: (time, task) -> time / 2
    shoes:    duration: (time, task) -> task is 'dance' and time / 2 or time
    magazine: duration: (time, task) -> task is 'shop' and time / 2 or time
    basket:   haul:     (count)      -> count * 2

    ears:     trait:    'Furry'
    vibrator: trait:    'Squirting'
    collar:   trait:    'Bondage'
    bottle:   trait:    'Water_Sports'
    buttplug: trait:    'Anal'
    cake:     trait:    'Cake_Farting'

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


