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

