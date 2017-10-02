path    = require 'path'
assert  = require 'assert'
{suite} =
joe     = require 'joe'

class TestArray extends Array

suite 'Array extensions', (suite, test) ->
  require (path.resolve '..', '..', 'lib', 'array'), TestArray

  test 'extends passed object', ->
    assert undefined is       Array::hasDupe
    assert undefined isnt TestArray::hasDupe

