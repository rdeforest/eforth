###

Utility library for describing an object model.

Usage:

    {a, an} = require './def'

    an 'ExamplePerson',
      is: an 'ExampleOrganism'
      has:
        name: String
        age: Number
        birthMother: an 'ExamplePerson'
        birthFather: an 'ExamplePerson'
        adoptiveParents: [an 'ExamplePerson']
      receives:
        perceive: (event) ->
          # code implementing perception
      does:
        respond: ->
          # code generating action events
      # etc.

    ExamplePerson.register() # or something like that?

###

class Model
  constructor: (modelName) ->
    # new Model 'ModelName'
    klass = Object.assign
    return cs.eval """
      class #{modelName} extends Model
        constructor: (propName) ->
    """

    # new ModelName 'referringPropName'
    if 'string' is typeof nameOrDescription
      return "#{nameOrDescription}": new @constructor

    # new ModelName ->
    if 'function' is typeof nameOrDescription
      if desc = nameOrDescription()
        return desc

    # Not creating a new Model and no name given, use default prop name
    # new ModelName
    name = @constructor.name
    name[0] = name[0].toLowerCase()

    return "#{name}": new @constructor

  hasProp: (name, info) ->

  hasProps: (propDicts...) ->
    for propDict in propDicts
      for name, info of propDict
        @hasProp name, info

  # 1:1
  has: (propName, model) ->
    if 'object' is typeof propName
      @has name, model for name, model of propName
    else
      @hasRelations[propName] = model

  # 1:n
  hasMany: (model) ->
    model.belongsTo @

  # n:1
  belongsTo: (model, propName = "#{model.name.toLowerCase}Id") ->
    @belongsToRelations[propName] = model

  is: (model) ->
    for key in [ 'hasProps', 'hasRelations', 'belongsToRelations' ]
      Object.assign @[key], model[key]

a = an = (name, desc) ->
  if 'function' is typeof desc and models[name]
    throw new Error "Refusing to re-define '#{name}'"

  models[name] or= (args) ->
    if propName = args[0]
      "#{}": desc()
    else
      desc() or new Schema name

module.exports = {Model, a, an}
