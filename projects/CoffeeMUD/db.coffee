# Object persistence, woo

MudObject = require './mud-object'

class ObjectDB
  constructor: (@dataDirectory) ->
    @names = {}
    @dataDirectory and @attemptLoad() or @initMinimal()
    @names.sys.call 'startup'

  create: (parent, opts = {}) ->
    new MudObject @, parent, opts

  addName: (name, obj) ->
    if @names[name]
      throw new Error "Object name conflict"

    @names[name] = obj

  initMinimal: ->
    sys  = @create null, name: sys
    root = @create null, name: root
    sys.setParent root
