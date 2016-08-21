
    { Model, IFace, Channel, Attribute } =
      MOP = require 'mop'

    Named = IFace
      name: 'Named'

      receives:
        nameStr:
          args: []
          results: Str
          fn: -> #MOP.get this, 'name'

    Person = Model
      name: 'Person'  # for tracebacks

      has:
        personName: String

      does:
        Named:
          share: [ 'name': 'personName' ]

    Position = Model
      name: 'Position'

      has:
        role: String

    Team = Model
      name: 'Team'

      hasMany:
        Position

    Position.addBelongsTo team: Team

    Employee = Model
      extends: Person

      hasMany: Position

      does:
        TeamMember: {}

    robert = Person.create name: "Robert de Forest"

    someTeam = Team.create name: "Some Team"

    contibuter = Position.create
      team: someTeam
      role: "contributer"

    robert.as Employee, 'addPosition', contributer


