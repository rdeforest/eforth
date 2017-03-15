###

# "Re-inventing Wheels" is the name of my "Soul Coughing" cover band

(Because "I'm rollin'")

I looked around and couldn't find a Trie implementation I liked, so here we go...

## Interface/usage

It does everything an Array does, and then some.

```coffee

Trie = require 'trie'

t = new Trie
t.add w for w in 'foo bar baz'.split ' '
console.log w for w in t
# foo
# bar
# baz

t.add w for w in fs.readfileSync('/usr/share/dict/words').split '\n'

# Magic to come...

```


###

isWord     = Symbol 'Trie node is also a leaf'
childCount = Symbol 'Trie node leaf count'

module.exports =
  class Trie
    constructor: ->
      @root = {}

    # would benefit from tail recursion optimization
    add: (word, from = @root) ->
      return from[isWord] = true and @ unless word.length

      @add word[1..], from[word[0]] ?= {}

    has: (word, from = @root) ->
      return (from[isWord]? and true) unless word.length

      return false unless child = from[first = word[0]]

      return @has word[1..], child

Trie::[Symbol.iterator] = (from = @root, prefix = '') ->
  if from[isWord]
    yield prefix

  for k, subTree of from
    yield from @[Symbol.iterator] subTree, prefix + k

