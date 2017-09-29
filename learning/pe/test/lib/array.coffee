path   = require 'path'
assert = require 'assert'
joe    = require 'joe'

joe.suite 'Array extensions', (suite, test) ->
  require (path.resolve '..', '..', 'lib', 'array'), Array

  test 'extends []', ->
    assert 

