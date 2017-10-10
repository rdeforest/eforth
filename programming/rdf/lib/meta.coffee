###

###

Meta = Symbol 'Meta'

class MetaClass
  @comment: """
      - obj[Meta]
       - a .classView (default is ClassView)
       - owned by MetaClass
       - returned by Class(obj)
       - Class(obj).create args...
        - constructs an object whose prototype is obj
        - sets .prototype to a child of obj.prototype
        - calls @init(instance, args...)
        - calls Class(instance).init(args...), if present

      - obj[obj[Meta].sym] is controlled by obj

      - obj(child) exposes obj[Class(obj).sym]

    """

  classView: ClassView

  constructor: ->
    if not new.target
      return @[Class(@).sym]

    @[Meta] = new @classView @

class ClassView
  constructor: (@class) ->
    @sym = Symbol "Meta #{@constructor.name}"

    return @class[Meta] ? @

  create: (definitions) ->
    { constructor = (->) } = definitions

    Object.setPrototypeOf constructor, @class

    Object.setPrototypeOf (constructor:: = {}), @class::
    
    for k, v of definitions when k isnt 'constructor'
      if k.startsWith '@'
        constructor[k[1..]] = v
      else
        constructor::[k] = v

    @init constructor

    return (constructor.apply constructor) ? constructor

  init: (instance) ->
    try Class(instance).init()

Class = (klass) -> klass[Meta]

ProtoObject = Class(MetaClass).create
  @comment: """
    I'm some kind of example, I guess?
  """

  constructor: ->
    # ...

Object.assign module.exports, { Class, MetaClass, ClassView }

