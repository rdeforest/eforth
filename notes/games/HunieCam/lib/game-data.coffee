###

resting is maybe 32 quarter hours * precent
as in
restTime = (stress) ->
  quarters = Math.ceil(stress / 100 * 32)
  hours: quarters >> 2, minutes: (quarters % 4) * 15

-  8: 0:45 -  3
- 17: 1:15 -  5
- 20: 1:30 -  6
- 31: 2:30 - 10
- 96: 7:45 - 31

first cig/booze visit is 2.5h

###

module.exports =
  townUpgradeEffects:
    accounting   : [2, 3, 5, 10, 20, 40, 80, 160, 250, 500]
    automation   : [15, 12, 10, 8,    6,  4,  2]
                 #   4   5   6  7.5  10  15  30
    training     : [2, 3]
    community    : [2, 3, 5, 8]
    aesthetics   : [2, 3]

  townUpgradesCosts:
    staffing     : [ 10,   25,  100, 250,      1000, 2500,       10000]
    accounting   : [ 20,   50,  100, 250, 500, 1000, 2500, 5000, 10000]
    capacity     : [ 50,        500,           5000,             10000, 25000, 50000]
    inventory    : [ 50,        250,           2500]
    productivity : [            100,           1000,             10000,               100000]
    automation   : [ 20,   50,  150, 500,      2500,             10000, 25000]
    training     : [            250,           1000]
    community    : [ 50,        250,           1000,   4000]
    aesthetics   : [            250,           1000]
    servers      : [ 50,        500,           5000,             50000]
    hardware     : [ 50,        500,           5000,             50000]
    advertising  : [            100, 350,      1500,   5000,     10000]

  durations:
    # uncertain of effect of style and skill on these two
    photoShoot:   (style, visits, rockHard) -> 15 * Math.min 32, style + (visits - 1) >> 1
    camShoot:     (skill, visits, rockHard) -> 15 * Math.min 32, skill + (visits - 1) >> 1
    shopping:     (style, rockHard) -> 8 + (style - 1) * 12
    stripping:    (skill, rockHard) -> 8 + (skill - 1) * 12
    cigAndBooze:  (rockHard) -> 6
    talentSearch: (visits) -> 4 + Math.min(visits, 5) * 6
    toyStore:     (visits) -> Math.min(visits + 1, 4) * 8

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


