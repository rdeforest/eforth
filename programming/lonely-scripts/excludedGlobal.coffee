# Limit global access to intended members

vm = require 'vm'

deepCopy = require './deepcopy'

valueIn = (l...) -> (v) -> v in l

keyOf = (o) -> valueIn Object.getOwnPropertyNames o

