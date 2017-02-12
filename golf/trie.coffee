assessNode = (prefix, node) ->
  prefix.length * node.leaves.length

class Trie
  constructor: (word = '') ->
    @kids = {}
    @add word
    @leaf = word.length is 0

  add: (word) ->
    return unless word

    for pfx, child of @kids when word.startsWith pfx
      child.leaf = true if word.length is 1

      return child.add word[pfx.length...]

    @kids[word[0]] = new Trie word[1..]

    return @

  forEachLeaf: (predicate, leader = '') ->
    ret = []

    for pfx, child of @kids
      ret.push(predicate leader + pfx, child) if child.leaf
      child.forEach predicate, leader + pfx

  leaves: ->
    @forEachLeaf (word) -> word

module.exports = Trie
