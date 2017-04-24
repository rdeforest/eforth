# This 'core' is more of a minimal-core initializer. It requires the
# underlying to db be empty.

assert = require 'assert'
fs     = require 'fs'

module.exports = ({COP}) ->
  new Promise (resolve, reject) ->
    sys = COP.create()

    asser.equal sys.id, 0, "db not empty? first object must have id 0, not #{sys.id}"

    root = COP.create()

    sys.setParent root
    sysAndRoot = {COP, sys, root}

    (require 'sysAndRoot') sysAndRoot
    (require 'util')       sysAndRoot
