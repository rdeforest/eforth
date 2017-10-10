{ Optional, Identity } = require './optional'

(require './String') String

module.exports.Class =
class Class
  constructor: (info = {}) ->

module.exports.VarRef =
class VarRef
  constructor: (info) ->
    { @instance, @definer, @name, @mode } = info

  value: ->
    @definer.getVar @instance, @name, @mode


# ObjRef exists to remove circular references from serialized DB.
module.exports.ObjRef =
class ObjRef
  constructor: (@db, @id) ->

  o: -> @db.lookupId @id

module.exports.VarDef =
class VarDef
  constructor: (@definerRef, @vars, @name, @defaultValue) ->

module.exports.Instance =
class Instance
  @comment: """
      An instance is an entity which lumps together
       - identity
       - category membership
       - owning variables (class and instance)
       - inheritance (class and instance)

      # Class vs Instance inheritance

      Whether an object acts as a Class or Instance depends on how it is
      addressed.
    """

  constructor: (def = {}) ->
    { @db, @id, @childOf, @instanceOf
      @classVars, @instanceVars, @category
    } = def

    @class = classWrapper @

    @db.byId[id] = o

    # This bit with instanceSymbol prevents variable name conflicts between
    # classes. Yes, it incurs additional overhead

    if hasVars
      @[instanceSym = Symbol()] =
        class   : Object.assign {}, @classVars
        instance: Object.assign {}, @instanceVars

      __vars  = (instance   , mode             ) -> ((instance?.o()[instanceSym] ?= {})[mode] ?= {})

      accessors =
        hasVar: (instanceRef, mode, name       ) -> name in Object.keys __vars instance, mode
        getVar: (instanceRef, mode, name       ) -> (__vars instance, mode)[name]
        setVar: (instanceRef, mode, name, value) -> (__vars instance, mode)[name] = value

      for name, fn of accessors
        Object.defineProperty @, name, configurable: true, value: fn.bind @

  findVar: (name, target = @) ->
    if @hasVar name, 'instance'
      new VarRef instance: target, definer: @, name: name, mode: 'instance'
    else
      @instanceOf.findVar name, target


# A DB 

module.exports.DB =
class DB
  constructor: ->
    @byId       = []
    @byName     = {}
    @categories = {}

    (sys = @define Sys:  {}).childOf =
    root = @define Root: {}

  @thaw    : (frozen) ->
    unless Array.isArray frozen
      throw new Error "Usage: .thaw [definitions...]"

    $ = init()
    $.create def for def from frozen
    $

  _cat          : (cat) -> Optional @categories[cat]
  removeFromCat : (cat, o) -> @_cat(cat) (cat) -> cat.remove o
  addToCat      : (cat, o) -> (@categories[cat] ?= new WeakSet).add o
  categories    :          -> Object.keys @categories
  inCategory    : (cat)    -> Optional @categories[cat]

  validateNames: (names) ->
    for name in names
      nameStr = String.valueIfString()

      switch
        when 'string' isnt typeof nameStr
          throw new Error "Value '#{name}' is not a string"
        when nameStr in @byNames
          throw new Error "Name '#{name}' already in use"

      nameStr

  lookupId : (name) -> Optional (@names[name] if name in Object.keys @names)

  lookup   : (name) -> (lookupId name) (id) -> $[id]

  _build   : (def)  ->
    { id           = @length
      parent       = @lookup 'Root'
      names        = []
      classVars    = {}
      instanceVars = {}
      category     = Optional()
    } = def

    def.names = @validateNames def.names

    new Instance { db: @, id, names, parent, classVars, instanceVars, category }

  _create   : (name, def = {}) ->
    if 'object' is typeof name
      def = name
      name = undefined

    def.names ?= []

    if 'string' is typeof name
      def.names.push name unless name in def.names


    for k, v of def
      def[k] = Optional v

    {id} = o = build def

    @

  redefine : -> throw new Error "Meaning of 'redefine' yet to be decided."

  define   : (nameAndDef) ->
    for name, def of nameAndDef
      if (id = lookupId name).present()
        redefine id, def
        continue

      @_create name, def

  freeze   : -> Array.from @byId

  install  : (global) ->
    global.$ = @
    global.define = @define.bind @
