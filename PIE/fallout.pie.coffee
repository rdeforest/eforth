
###

A pattern is a collection of expectations and ways to meet them
An assembly is a collection of assemblies and parts
A part is a shape (assembly constraints) and features

###

pattern 'settlement',
  has:
    boundary: 'edge of settlement'
    neighborhood: 'list of nearby stuff'
    structures: []
    jobs:
      production: []
      defense: []
      route: []
    residents: []
    facilities: []
    generators: []

pattern 'resident',
  has:
    home: 'settlement'
    name: '...'
    story: '...'
    appearence: {}

pattern 'part',
  has:
    shape: 'a built-in, structure or whatever'
    connections: [ 'how it connects to its peers' ]
    features: [ 'what it does' ]

pattern 'structure',
  has:
    footprint: {}
    blueprint: [ 'parts and their positions' ]
  reports:
    features: [ 'what it does' ]

action 'compare',
  takes: 'pattern', 'instance'
  gives: 'differences'



a 'settlement',
  contains: 'construction'
  with: 'location'

a 'construction',
  contains: 'feature'

an 'assembly',
  contains: 'connection'

a 'connection',
  contains: 'part'

an 'assembly', actsLike: 'part'

a 'part',
  has:
    height: Number
    width: Number
    depth: Number
  contains:
    connector:
      shape: AnObject
      location: Position
    ingredient:
      material: AnObject,
      count: Number

a 'settlement', wants: 'foodProduction', per: 'settler', plus: 2
a 'settlement', wants: 'waterProduction', per: 'settler', plus: 2
a 'settlement', wants: 'defenseProduction', per: 'settler', times: 3

a 'settlement', wants: 'settler', toDo: [ 'corn', 'tato', 'mutfruit', 'trade' ]
