# Convert letter lists to uniqueness ids.

util = require 'util'

module.exports =
  wordsToKeys: (words, andSeen) ->
    seen = ([] for letter in words[0])

    result = for word in words
      for letter, position in word
        if (id = seen[position].indexOf letter) < 0
          id = seen[position].length
          seen[position].push letter
        id

    if util.isFunction andSeen
      andSeen seen

    result
