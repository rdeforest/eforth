###

A MetaClass instance is responsible for managing the meta-state of the
class it was contructed with.

The difference between a JClass and regular ECMAScript objects is that JClass
objects provode meta-object-protocol features for the 'klass' they were created for.
Constructing a class with JClass grants that class the Joosed benefits _plants
crave_.

Too create a Joosed class, do something like

ExampleClass = JClass ->
  isa ParentClass, AnotherParent
  has 'someProperty'
  does 'someMethod', (args...) -> code

Now 'someMethod' will have an @self pointing to the actual instance and other
instance variables which are private to ExampleClass methods.

To continue adding parents, properties and methods to that object, try...

JClass.andThen ExampleClass, ->
  has 'anotherProperty'
  does 'anotherMethod', -> ...

###

jSym = Symbol 'Joosed Metadata key'
meta = (o) -> o[jSym]

module.exports =
  class MetaClass
    @startDefining: (name) ->

    constructor: (@klass) ->
      if meta @klass
        throw new Error "#{@klass.name} already has a MetaClass"

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

    addMethod: (method) ->
      if method.canAddToObject @
        method.install meta @

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


