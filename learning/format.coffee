###

  Augment util.inspect to handle self-referential structures more elegantly.

  Output is valid CoffeeScript which will at least partially re-construct the
  object. Symbols will be created but cannot be made to match the originals
  unless the originals are passed in as options.symbols. If depth is a number
  then deeper objects show up as "refs.depth", which will be assigned a
  symbol.

  If an Array or TypedArray exceeds maxArrayLength, elements after that length
  will be summarized with "refs.truncated".

  Example:

  o = [
    (new Map)
      .set 1, 2
      .set o, o
    foo: bar: baz: o
  ]

  inspect o, depth: 1
  => """
    refs = []; refs.depth = Symbol('depth')
    (refs.push o = [
      (new Map)
        .set 1, 2
        .set refs[0], refs[0]
      foo: refs.depth
    ]; o)
  """

  inspect o, depth: null
  => """
    refs = []; refs.depth = Symbol()
    (refs.push o = [
      do ->
        m = new Map
        m.set refs[0], refs[0]
      foo:
        bar:
          baz: refs[0]
    ]; o)
  """

###

util = require 'util'

Object.assign module.exports,
  util:
    inspect:
      uInspect = util.inspect

  inspect: inspect = (o, options = {}) ->
    (new Inspector options).inspect o

  install: -> util.inspect = inspect

class Inspector
  @globalMap:
    new Map ( Object
                .entries global
                .map ([k, v]) -> [v, k]
            )

  constructor: (@options = {}) ->
    @options.indent ?= "  "
    #@options.asyncAfter = 2000 # milliseconds

  inspect: (@o) ->
    @inspected = []
    @refs = []
    @seen = []
    #@startedAt = Date.now()
    @rendering = ""

    Node
      .inspect @, o, 0
      .render()

    #(new Promise (@resolve, @reject) => @_inspect o)
    #  .then => @render()

  haveReference: (o) ->
    if -1 < idx = @seen.findIndex o
      @refs[idx] = true
      return "refs[#{idx}]"
    else
      @refs.push o
      false

  _________inspect: (o, depth = 0) ->
    return uInspect o, options  if 'object' isnt typeof o

    if -1 < idx = @seen.findIndex o
      @refs[idx] = true
      return "refs[#{idx}]"

    if options.depth and depth >= options.depth
      @refs.depth = true
      return "refs.depth"

    if  (not @async)                      and
        (timeout = @options.asyncAfter)   and
        (Date.now - @startedAt > timeout)
      @async = Date.now()

      setImmediate =>
        @_inspect o, depth

      return

    @seen.push o

    klass = @relevantClass o
    [klass, @[klass] o, options, @seen]

  relevantClass: (o) ->
    return Array if Array.isArray o

    for klass in [Map, WeakMap, Set, WeakSet]
      return klass if o instanceof klass

    return Object

  refWrapInspected: (klass, inspected) ->
    [lBrace, rBrace] = @[klass.name].braces or [
      "do ->"
      ""
    ]

    [ "(refs.push o = #{lBrace}"
      (indent lines, options.indent)...
      "#{rBrace}; o)"
    ]

  # Each Klass: (o) -> returns a list of
  #   [klass, inspectionInfo...]

  Array: ((o) ->
    trucated = false

    if @options.maxArrayLength
      o = o[..maxArrayLength]
      @refs.truncated = trucated = true

    inspected = o.map (e) -> inspect e, @options

    if truncated
      inspected.push "refs.trucated"

    inspected
  ).braces = "[]"


  WeakMap : ((o) -> @Map o).braces = ["(new WeakMap)", ""]
  WeakSet : ((o) -> @Set o).braces = ["(new WeakSet)", ""]

  Map     : ((o) ->
    for [k, v] from o.entries()
      [ Inspector.Map.Entry
        @_inspect k
        @_inspect v
      ]
  ).braces = ["(new Map)", ""]

  Set     : (o) ->
    for v from o
      @_inspect v
  ).braces = ["(new Set)", ""]

  indented: (lines, indent) ->
    lines
      .map (l) -> indent + l
      .join "\n"

nodeType = (klass) ->
  Object.setPrototypeOf klass, Node
  klass.class ?= global[klass.name]
  klass

class Node
  @comment: """
    My children know how to inspect a type of
    value and how to render the result. Their
    instances represent the results of inspecting
    a portion of a tree of data. 

    Node class methods
      .inspect inspector, value, depth
      => instance

    Must override:
      ::render

    Optional overrides:
      .class is the what a value must be an instanceof to be inspected by this node class

      ::canInspect value
      => this class is responsible for that value

      ::inspect() is the per-class inspection logic invoked by the constructor

      ::render => a string representing the instance's value

      Node.inspectors is ordered to ensure the right inspector is created for a value.
  """

  @canInspect: (value) ->
    # Through Object.setPrototypeOf magic, this is the default for constructos
    # which extend Node.
    value instanceof @class

  @class: null # should be the relevantClass of the object this Node type inspects

  @inspectors: [
    nodeType class Node.Global
      @canInspect: (o) -> Inspector.globalMap.has o

      inspect: ->
        name = Inspector.globalMap

        @values = [ "global[#{JSON.stringify name}]" ]

      render: ->

    nodeType class Node.Function
      @canInspect: (o) -> 'function' is typeof o
      render: ->
        if global[@value.name] is @value
          return "global.#{@value.name}"

        code = @value.toString()
        "(new Function " + '"""' + + '"""' + ")"

    nodeType class Node.Primative
      @canInspect: (o) -> 'object' isnt typeof o

      render: -> uInspect @value, @inspector.options

    nodeType class Node.Array
      @canInspect: Array.isArray

      inspect: ->
        @values = (Node.inspect @inspector, e) for e in @value

    nodeType class Node.Map

    nodeType class Node.WeakMap

    nodeType class Node.Set

    nodeType class Node.WeakSet

    nodeType class Node.Object
  ]

  @inspect: (inspector, value, depth) ->
    if 'function' is typeof o
      return new Node.Function inspector, value

    if 'object' isnt typeof o
      return new Node inspector, value

    if ref = inspector.haveReference o
      return new Node.reference ref

    for klass in Node.inspectors when Node[klass].canInspect? value
      return new klass inspector, value, depth

  constructor: (@inspector, @value, @depth = 0) ->
    @values = @inspect

  className: -> @constructor.class.name

  braces: ["(new #{@className()})", ""]


  render: ->
    [ @lBrace
      do -> (
        l = 0
        values = @values[..@inspector.options.maxArraySize]

        if values.length isnt @values.length
          truncated = true

        strings = values.map (v, i) ->
          if l > @options.maxLineLength
            tooLong = true

          l += (if 'string' isnt typeof v
                  v = v.render()
                else
                  v
          ).length

          l += 2 if i # for ", "
          v

        ( if strings[-1..][0]
            strings
              .filter (s) -> s
              .concat "..."
          else
            strings
        ).join ", "

        for v, i in strings
          if l += v.length + 2 > 80
            return (strings[..i - 1].concat ", ...").join ", "

        strings.join ""
      )...
      @rBrace
    ].join "\n"


mapOverIterator = (it, fn) -> fn e for e from it














class Node.Object extends Node
  @class: Object

  inspectValue: ([k, v]) ->
    [ JSON
        .stringify "#{k}": null
        .match(/^.(.*):null}/)[1]
      @inspector._inspect v
    ]

  braces: ["", ""]
  render: ->
    



