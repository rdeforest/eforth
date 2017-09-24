# Maps objects to and from json values. Participating parent objects must
# provide '.fromTree' and '.toTree' static methods.

# klass.toTree(o) must return an object which, when passed to fromTree,
# approximately re-creates the original object 'o'. It is recommended that the
# value be arguments to the constructor or something similar.
#
# The returned value will have klass.name and klass.toTree.libName stored in a
# symbol-named property.

# addDefaultTreeification(klass, libName) will add default toTree/fromTree
# methods to klass which will work if 'new klass tree: instance' would have
# the expected result.

herritageSym = Symbol 'constructor'

toTree = (o) ->
  tree = {}
  ctorName = (ctor = @o.constructor).name

  if 'string' isnt typeof libName = ctor.toTree.libName
    libName = undefined

  Object.assign {}, ctor.toTree @, {ctorName, libName}

defaultRequire = ({libName}) ->
  require libName

fromTree = (tree, require = defaultRequire) ->
  unless 'object' is typeof parentInfo = tree?[herritageSym]
    throw new Error 'Invalid tree. Not an object or no valid parent info found.'

  unless ctor parent = require parentInfo
    throw new Error "Parent '#{parentInfo.name}' could not be obtained"

  instance = parent.fromTree tree

addDefaultTreeification = do (toTree, fromTree) ->
  (klass, libName) ->
    fromTree = (tree)     -> new klass tree

    toTree   = (instance) ->
      tree:
        Object.assign {},
          ( Object.getOwnPropertyNames instance
              .filter (prop) -> 'function' isnt typeof instance[prop]
              .map    (prop) -> "#{prop}": instance[prop]
          )...

    if 'string' is typeof libName
      toTree.libName = libName


    Object.assign klass, {toTree, fromTree}

Object.assign module.exports, {toTree, fromTree, addDefaultTreeification}
