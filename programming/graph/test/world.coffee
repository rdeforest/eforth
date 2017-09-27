path            = require 'path'
fs              = require 'fs'
child_process   = require 'child_process'

{ suite, test } = require '../util/setup-testing'

{ World }       = require '../src/world'

testDir         = path.resolve __dirname, 'testWorld'
testURL         = 'file:///' + testDir

before =
after  = ->
  child_process.exec_sync 'rm -rf ' + testDir

suite 'World', (suite, test) ->
  suite 'constructor', (suite, test) ->
    @on 'test.before', before
    @on 'test.after',  after

    test 'initializes a missing db', (complete)  ->
      world = new World testURL
      testObj = id: 1
      
      assert world.lookupId(1), undefined
      (world.add testObj)
        .then ->
          assert world.lookupId(1), testObj
          complete()

      cleanup testDir

    test 'resumes an existing db', ->
      world = new World testURL
      testObj = id: 1
      world.add testObj

      worldAgain = new World testURL
      assert testObj = world.lookup id: 1
