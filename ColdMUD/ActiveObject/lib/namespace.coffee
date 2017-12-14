keys = Object.keys

makeError = (name, argNames, message) ->
  argStr = argNames.join ', '
  argExpr = "[$][(](#{argNames.join '|'})[)]"
  message = "`#{message.replace new RegExp(argExpr),
    (all, parts...) -> "$(#{parts[1]})"}`"

  eval """
    class #{name} extends Error {
      constructor(#{argStr}) {
        super(#{message});
      }
    }
  """

KeyExists         = makeError 'KeyExists'         , ['fullPath', 'key' ], "Key '\#{fullPath}::\#{key}' already exists"
InvalidIdentifier = makeError 'InvalidIdentifier' , ['identifier'      ], "Identifier '\#{identifier}' is invalid"
UnknownNamespace  = makeError 'UnknownNamespace'  , ['namespace'       ], "Unknown namespace '\#{namespace}'"
NotABranch        = makeError 'NotABranch'        , ['fullPath', 'key' ], "'\#{fullPath}::\#{key}' is not a Namespace branch"

identifier = /[a-zA-Z_$][a-zA-Z0-9_$]*/

class Namespace
  @comment: '''
    I exploit the :: shortcut of CoffeeScript to provide namespaces using :: as
    their separators.

    Using :: means we can use . for messages to a given level of a namespace as long as the message name isn't "prototype".

    Construction:
        Example = makeNamespace 'Example'

    Methods:
      ::add - extend a namespace, creating sub-keys as needed

        Example.add
          Foo: 'bar'
          Baz: Bumble: (world) -> "hello #{world}"

        console.log Example::Foo
    => "bar"

        console.log Example::Baz::Bumble 'world'
    => "hello world"

      ::parent - parent namespace, if any

        bumble = Example::Baz::Bumble
        console.log bumble.parent
    => "Baz"

      ::fullPath - Returns a string which probably matches the in-code full path to the namespace in question, including its parents

        console.log bumble.parent.fullPath
    => "Example::Baz"

    Note that methods prefixed with underscore are direct operations (no branch traversal).
  '''

  @pathFromString: (str) ->
    unless str.match /// ^ #{identifier} ( :: #{identifier} )* $ ///x
      throw new InvalidIdentifier str
    
    parts = str.split '::'

    try
      root = eval "#{parts[0]}"
    catch e
      throw new UnknownNamespace parts

  constructor: (@name, @parent) ->
    @prototype = {}

    if @parent not instanceof Namespace
      @parent[@name] = @

  _get:      ( key        ) -> @prototype[key]
  _set:      ( key, value ) -> @prototype[key] = value
  _del:      ( key        ) -> @prototype[key] = undefined
  _have:     ( key        ) -> undefined isnt @_get key
  _isBranch: ( key        ) -> @_get(key) instanceof Namespace

  get:   ( key, keys... ) ->
    v = @_get key

    switch
      when not v           then throw new KeyNotFound @fullPath, key
      when not keys.length then v
      when not _isBranch v then throw new NotABranch @fullPath, key
      else                      v.get keys...

  has:   ( key, keys... ) ->
    return false unless branch = @_get key

    return keys.length is 0 or branch.has keys...

  isBranch: (key, keys...) ->
    unless branch = @_get key
      return false

    if keys.length is 0
      return branch instanceof Namespace

    branch.isBranch keys...

  add: (value, key, keys...) ->
    if keys.length
      branch = (@prototype[name] ?= new Namespace name, @)
      branch.add value, keys...
      return @
    
    if @_have key
      throw new KeyExists fullPath, key

    @_set key, value

  set: (value, key, keys...) ->
    if @prototype

  del: (key, keys...) ->
    if not keys.length
      return @_del key

    if not @_isBranch key
      return

    @_get(key).del keys...

Object.defineProperties Namespace::,
  fullPath:
    get: ->
      prefix = if @parent then @parent.fullPath + "::" else ""
      prefix + @name
