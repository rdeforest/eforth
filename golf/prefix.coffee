#fs = require 'fs'

#dict = '/usr/share/dict/words'
#words = fs.readFileSync(dict).split /\n/

module.exports =
  class Trie
    constructor: ->
      @t = {}

    add: (s, at = @t) ->
      if s.length is 0
        at[''] = true
        return

      [front, rest...] = s

      @add rest, (at[front] ?= {})

    have: (s, at = @t) ->
      if s.length is 0
        return at[''] is true

      return at[s[0]] and @have s[1..], at[s[0]]

    getAll: (s, at = @t) ->
      if s.length
        if from = at[s[0]]
          @getAll(s[1..], from).map (str) -> s[0] + str
        else
          []
      else
        (if at[''] then [''] else [])
          .concat Object.keys(at).map (k) => @getAll('', at[k]).map (s) -> k + s
          .reduce ((a, b) -> a.concat b), []

    deepest: (at = @t) ->
      return undefined unless keys = Object.keys at

      if keys.length is 1 and keys[0] is ''
        return ''

      keys.filter (k) -> k isnt ''
        .map (k) => @deepest at[k]

      return "not done"

    width: (s, at = @t) ->
      if s.length is 0
        (Object
          .keys at
          .map (k) => @width '', at[k]
          .reduce ((a, b) -> a + b), 0
        ) + if at[''] then 1 else 0
      else
        if not at[s[0]]
          0
        else
          @width s[1..], at[s[0]]

    score: (pfx) ->
      pfx.length * @getAll(pfx).length**2
