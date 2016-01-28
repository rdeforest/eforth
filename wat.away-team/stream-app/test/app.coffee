should = require 'should'
EventEmitter = require 'events'

streamApp = null

State = null
app = null
initState = null
states = {}
inputNoted = []
noteInput = (l) -> inputNoted.push l

class MockDuplex extends EventEmitter
  constructor: (sink) ->

  send: (d) -> @emit 'data', d

  write: (d) -> sink(d)

module.exports =
  'stream-app':
    'should be a function': ->
      (typeof streamApp = require '..').should.equal 'function'
    '#State should be the State class': ->
      (typeof State = streamApp.State).should.equal 'function'
    '#connect(stream) should start a session in initState': ->
      initState = class OurState extends State
        _lineInput: (l) -> noteInput l
      app = streamApp initState
      myStream = new MockDuplex
      app.connect myStream
      myStream.send testData = 'test123'
      inputNoted.shift().should.equal testData
  'app':
    '#connect(stream) should return a session in initState': ->
  ###
    'function should return an app': ->
      (typeof app = streamApp()).should.equal 'function'
      app.initState.should.equal initState
  ###
