# Back up and restore 'global' or 'window'
# Side-effect: loads underscore, which adds 'root' to root
#
#   yo dawg,
#     I heard you like namespaces, so I named your namespace in itself so you
#     can look up looking things up while you're looking things up
#
# - xyxbit

_ = require 'underscore'

savedRoot = _.extendOwn {}, root

module.exports = ->
  declare: (o, name, fn) -> o[name] = root[name] = fn

  restore: ->
    _.extendOwn root, savedRoot

    for key in _.keys root
      if not savedRoot.hasOwnProperty key
        delete root[key]
