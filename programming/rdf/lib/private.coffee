instanceData = new Map

module.exports.Private =
Private = (defaults = -> {}) ->
  instanceData.set sym = Symbol(), new Map

  accessor = ->
    classData = instanceData.get sym

    unless data = classData.get @
      classData.set @, data = defaults()

    data
