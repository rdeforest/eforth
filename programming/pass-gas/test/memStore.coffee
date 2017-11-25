{assert, suite, test, lib} = require '.'

{ MemStore } = lib 'models/memStore'

suite 'MemStore', ->
  test 'Empty store is empty', ->
    store = new MemStore
    assert.equal 0, store.size, "store.size is 0"

  test 'Can add an entry', ->
    store = new MemStore
    [ key, value ] = [ Math.random(), Math.random() ]
    store.put key, value

  test 'Can fetch an entry', ->
    store = new MemStore
    [ key, value ] = [ Math.random(), Math.random() ]
    store.put key, value
    assert.equal store.get(key), value, "Got back what we put in"

  test 'Cannot overwrite an entry', ->
    assert.throws ->
      store = new MemStore
      [ key, value ] = [ Math.random(), Math.random() ]
      store.put key, value
      store.put key, value

  test 'Correctly reports its size', ->
    store = new MemStore

    for i in [0 .. max = Math.ceil 2 + Math.random()*10]
      [ key, value ] = [ Math.random(), Math.random() ]
      store.put i, value
      continue

    assert.equal store.size, max + 1
