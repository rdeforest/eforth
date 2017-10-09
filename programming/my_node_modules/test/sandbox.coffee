{ suite
  assert
} = require '../lib/setup-testing'

suite "Sandbox", (suite, test) ->
  { Sandbox, Sandboxed } = require '../lib/sandbox'

  box = new Sandbox
    testvar: inSandbox = Symbol()
    counter: 0
    method: ->
      counter++
      global

  global.testvar = outsideSandbox = Symbol()
  global.counter = 0

  suite "methods see fake global", (suite, test) ->
    inside = box.method()

    test "inside isnt global", -> assert.notEqual inside,         global

    test "inside.testvar",     -> assert.equal    inside.testvar, inSandbox
    test "inside.counter",     -> assert.equal    inside.counter, 1
    test "outside.testvar",    -> assert.equal    global.testvar, outsideSandbox
    test "outside.counter",    -> assert.equal    global.counter, 0

  suite "new properties show up in old methods", (suite, test) ->
    box.newvar = newvar = Symbol()

    test "newvar", -> assert.equal box.method().newvar, newvar
