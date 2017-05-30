#
# Usage:
#
# class MyClass
#   ...
#
# new Builder MyClass,
#   foo: default: 'foo'
#   bar: validator: -> true
#   etc: {}
# 
# built = (MyClass.builder()
#   .bar 'bar'
#   .etc 'etc'
# )()
#
# built.foo is 'foo'
# => true


defines = (obj, name) -> Object.hasOwnProperty obj, name

class Builder
  constructor: (@klass, @fields) ->
    @klass.builder = @_makeBuilder()

    for name, {validator} of @fields when not validator
      @fields[name].validator = (v) -> v

  _makeBuilder: ->
    provided = {}
    realBuilder = => @_finish provided

    builder = new Proxy {},
      get: (target, property, receiver) =>
        (value) => provided[property] = validator value
          
    builder

  _finish: (provided) ->
    for name, {default: def} of @fields when def and provided[name] is undefined
      provided[name] = def

    new @klass provided


module.exports = {Builder}
