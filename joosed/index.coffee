currentlyDefining = null
definers = {}

###

A PropertyDescriptor describes and manages a specific future, current or past
property definition on a klass.

Properties have optional validation and maybe other features in the future?

###

class PropertyDescriptor
  constructor: (@definer, @name, opts = {}) ->
    { @validator = null
      @mode      = 'rw'
      @readable  = @mode.includes 'r'
      @writeable = @mode.includes 'w'
      @isa       = 'any'
    } = opts

    if 'string' isnt typeof @definer?.name or definers[@definer.name] isnt @definer
      throw new Error "Property definers must have a unique .name"

    @definers[@definer.name] = @definer

  valid: (v) ->
    (@isa in [ 'any', typeof 'v'] or v instanceof @isa) and
      @validator v

  addToDefiner: ->

  removeFromDefiner: ->

###

A MethodDescriptor describes and manages a specific future, current or past
method definition on a klass.

###

class MethodDescriptor
  @definersOf: {}

  constructor: (@definer, @name, @fn, @opts = {}) ->
    (@definersOf[@name] ?= []).push @

  canAddToObject: (target) ->
    if defined = target.lookupMethod @
      if defined.definer is target
        return @replaceMethodOn target

      if defined.final
        throw new Error "Cannot override final method #{@name}"

    if @final
      for definer in MethodDescriptor.definersOf[definer.name]
        if definer.hasAncestor @definer
          throw new Error "Cannot add final method that is already overriden in a child"

  destroy: ->
    @definer.removeMethod @

    @definersOf[@name] =
      @definersOf[@name]
        .filter (def) -> def.definer isnt @definer

###

The MetaClass instances are responsible for managing the object state of the
classes and the instances of the classes they are contructed with.

The difference between a JClass and an instance is whether it was constructed
with the JClass function. Constructing a class with that function grants it
the Joosed benefits plants crave.

Too create a Joosed class, do something like

Example = JClass ->
  isa ParentClass, AnotherParent
  has 'someProperty'
  does 'someMethod', (args...) -> code

Now 'someMethod' will have its own object state independent of the methods on
ParentClass and AnotherParent.

###

class MetaClass
  constructor: (@klass) ->
    if exists = @klass[jSym]
      return exists

    @klass[jSym] =
      Object.assign @,
        isa       : []
        children  : []
        instances : []
        has       : {}
        does      : {}
        data      : {}

  createContext: (definer, self) ->
    meta      = @klass[jSym]

    ctx       = meta.data[definer]
    ctx.self  = self
    ctx.super = meta.super.bind @

  addMethod: (definer, name, fn, opts = {}) ->
    method = new MethodDescriptor definer, name, fn, opts

  spawn: (args...) ->
    @instances.push instance = new @klass args...
    return instance

  destroy: (instance) ->
    @instances = @instances.filter (i) -> i isnt instance
    return @klass

  inheritFrom: (parent) ->
    for method in parent.methods
      @inheritMethod method

    return @

  inheritMethod: (method) ->
    @klass::[method.name] = (args...) ->
      (method.fn.bind @makeContext method.definer) args...

    for child in @children
      child.inheritMethod method

    return @

  methodConflict: (parent) ->
    for method in parent.does
      if @klass::[method.name]
        return method.name

  beforeMethod: (methodName, fn) ->
    if not definer = @lookupMethod methodName
      throw new Error "#{methodName} not defined"

    origFn = @klass::[methodName]
    wrapper = (origFn, args...) ->
      fn origFn, args...

    wrappingMethod = new MethodDescriptor @, methodName, wrapper.bind @makeContext @

  afterMethod: (methodName, fn) ->
    if not definer = @lookupMethod methodName
      throw new Error "#{methodName} not defined"

  hasAncestor: (parent) ->
    return true if parent is @
    return true for p in parents when p.hasAncestor parent

  addParent: (parent) ->
    return if @hasAncestor parent

    if conflict = @methodConflict parent
      throw new Error "cannot add parent due to conflicting method '#{conflict}'"

    @inheritFrom parent

JClass = (fn, reDefining = null) ->
  if currentlyDefining isnt null
    throw new Error "Assumptions violated: JClass definition function must be synchronous"

  if reDefining
    currentlyDefining = reDefining[jSym]
  else
    currentlyDefining = new MetaClass defining

  fn()

  currentlyDefining = null
  return defining

JClass.andThen = (klass, fn) -> JClass fn, klass

usage = ->
  throw new Error "Joosed verbs are meaningless outside a JClass definition"

module.exports =
  JClass: JClass

  isa: (parents...) ->
    usage() if currentlyDefining is null

    currentlyDefining.addParent parent for parent in parents

  has: (propertyInfo) ->
    usage() if currentlyDefining is null

    for propName, info of propertyInfo
      info = grokPropertyInfo info
      definition.has[propName] = info

  does: (methodInfo) ->
    usage() if currentlyDefining is null

    for methodName, info of methodInfo
      definition.addProperty Object.assign name: methodName, info

  before: (methodName, fn) ->
    usage() if currentlyDefining is null

    currentlyDefining.beforeMethod methodName, fn

  after: (methodName, fn) ->
    usage() if currentlyDefining is null

    currentlyDefining.afterMethod methodName, fn

  # with: (role) ->
