class ModelDef
  constructor: (@name) ->
    @props    = {}
    @messages = {}
    @methods  = {}

  has: (info) ->
    if info instanceof ModelDef
      lcname = info.name[0].toLowerCase().concat info.name[1..]
      info = "#{lcname}": info

    (@props[name] = info) for name, info of info

    return @

  receives: (info) ->
    for name, message of info
      @messages[name] = message

    return @

  does: (info) ->
    for name, method of info
      @methods[name] = method

    return @

a = an = (name, infoFn) ->
  infoFn ?= ->
  infoFn a.defs[name] ?= new ModelDef name

a.defs = {}

tests =
  nestedDefs:
    a 'Top', (_) ->
      _.has a 'Middle', (_) ->
        _.has a 'Bottom'

module.exports = {a, an, tests}
