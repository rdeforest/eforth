v8 = require 'v8'

{ suite
  assert
} = require '../lib/setup-testing'

suite "Private", (suite, test) ->
  { Private } = require '../lib/private'

  priv = Private()

  test "Private() returns an accessor", ->
    assert.equal 'function', typeof priv

  class TestPriv
  Object.defineProperty TestPriv::, 'priv',
    get: priv

  a = new TestPriv

  test "Accessor returns an object", ->
    assert.equal 'object', typeof a.priv

  a.priv.mutation = true

  test "Returned object retains mutations", ->
    assert.equal true, a.priv.mutation

  b = new TestPriv

  test "Returned object is not shared among objects", ->
    assert.notEqual a.priv, b.priv

  test "Data is not stored on instances", ->
    # This isn't exactly the real requirement. The requirement is that the
    # data not be recoverable via means other than the accessor. This test
    # just assures us that the implementation isn't naive.
    priv = Private()
    o = {}
    (priv.call o).someData = 'yep'

    assert.equal 0, Buffer.compare v8.serialize({}), v8.serialize o
