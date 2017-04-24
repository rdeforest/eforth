# DSL for declarative object/class construction
#
# usage:
#
#     define = require 'define'
#
#     define 'Example', ->
#       @has
#         foo:
#           is: 'rw'
#           isa: 'number'
#         bar:
#           is: 'ro'
#           isa: 'string'
#
#       @does
#         update: (updates) ->
#           @applyUpdates updates

built = {}

module.exports = (name, builder) ->
  o = built[name] or new JObject

  

