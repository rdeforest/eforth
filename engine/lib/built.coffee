#
# Usage:
#
# class MyClass
#   ...
#
# new Builder MyClass, foo: {}, bar: {}
# 
# (MyClass.builder()
#   .foo 'foo'
#   .bar 'bar')()
#
defines = (obj, name) -> Object.hasOwnProperty obj, name

class Builder
  constructor: (@klass, @fields, buildWith = @defaultBuildWith.bind @) ->
    @klass.builder = @makeBuilder.bind @
    @fields[name].validator = (v) -> v for name, {validator} of @fields when not validator
    @idDefaults()

  idDefaults: ->
    @defaults = Object.assign {},
      (for name, info of @fields when defines info, 'default'
        if 'function' isnt typeof def = info.default
          def = -> def)...

  defaultBuildWith: (built) ->
    builtProps = Object.getOwnProperyNames built

    for fName, defFn of @defaults when not defines builtProps, fName
      built[fName] = fInfo.default built

    new @klass built
    
  makeBuilder: (args...) ->
    builder = -> buider._buildWith builder.built

    Object.assign builder,
      _built: {}
      _fields: @fields
      _defaults: @_defaults
      _add: @_add

      (for name of @fields
        "#{f.name}": (value) -> @_add builder._fields[name], value
      )...

    builder

  _add: (fieldInfo, value) ->
    {name, validator} = fieldInfo
    @_built[name] = validator value
    @

module.exports = {Builder}
