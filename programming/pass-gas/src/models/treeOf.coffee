cs = require 'coffeescript'

{ Managed } = require './managed'

TreeOf = (type, subtreesName, membersName) ->
  klass = cs.eval """
    class #{pluralName or ''} extends Managed
      constructor: ->
        @subtrees = []
        @members  = []
  """

  klass::contains = (item) ->
    item = item.uuid if item instanceof Persisted

    (item is @       ) or
    (item in @members) or
    (-1 isnt @subtrees.findIndex (tree) -> tree.contains item)

  klass::["add" + subtreesName || 'Tree'   ] = (tree) ->
    @checkMutable(); @subtrees.push tree

  klass::["add" + membersName  || 'Member' ] = (member) ->
    @checkMutable(); @members .push tree

  klass

Object.assign module.exports, { TreeOf }
