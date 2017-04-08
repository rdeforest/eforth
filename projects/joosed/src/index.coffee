MetaClass        = require './class'
MethodDescriptor = require './method'

objects = {}

class Definition
  constructor: (@name, @definer) ->
    @$ =
      @props = {}
      @methods = {}
      @before = {}
      @after = {}
      @parents = new Set

    if exists = objects[@name]
    @resume exists

    @definer()
    return @finish()

  finish: ->
    method = if objects[@name] then "enhance" else "create"
    objects[@name] = Joose[method] @

  # isa Foo, Bar, Etc
  isa: (parents...) ->
    @parents.add parent for parent in parents

  # has propName: is: 'rw', isa: 'string'
  has: (propertyInfo) ->
    for propName, info of propertyInfo
      @props[propName] = info
  does: (methodInfo) ->
    for methodName, info of methodInfo
      @addMethod new MethodDesriptor Object.assign name: methodName, info

  before: (methodName, fn) ->
    @before[methodName] = fn

  after: (methodName, fn) ->
    @before[methodName] = fn
    @afterMethod methodName, fn

module.exports =
  define: (definitions = {}) ->
    for name, definer of definitions
      sandbox.defining = objects[name] ?= MetaClass.startDefining name
      sandbox.run definer

