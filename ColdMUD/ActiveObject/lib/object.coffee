class ActiveObject
  @comment:  """
    I implement AOclass/AOinstance by combining the implementations of its facets.

      - Inheritor
      - Definer
      - Method
      - Property

  """

  @o:
    root: root = new ActiveObject require 'mindb/root'
    sys:  sys  = new ActiveObject require 'mindb/sys'

  constructor: (@db, info) ->
    if 'string' is typeof info
      info = name: info

    if info instanceof ActiveObject
      info = parent: info

    if 'object' isnt typeof info
      throw new Error "Don't know how to initialize an ActiveObject from #{JSON.stringify info}"

    { @parent  = ActiveObject
      @id
      @name
      @comment = ""
      load
    } = info

    if @name
      if (other = ActiveObject.o[@name]) and other isnt @
        throw new Error "BUG: Creating or loading an object whose name (#{@name}) is already in use"

    if @id and (load or @db.exists @id)
      @load()
      @parent.childLoaded @
    else
      @parent.childCreated @
      @save()

  ancestors: ->
    parents = []
    parent = @parent

    loop
      parents.push parent
      parent = @parent.parent

      break if ActiveObject.o.root is parent

  childLoaded: (child) ->
    for parent in child.ancestors()

  childCreated: (child) ->

  save: ->
    @db.store @serialized()

    @

  load: ->
    @deserialize @db.fetch @

    @

  deserialize: (frozen) ->
    @loadDefs  frozen
    @loadState frozen

