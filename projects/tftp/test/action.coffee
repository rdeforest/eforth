Action = require '../src/action'

mockProcess =
  stdout:
    log: []
    write: (bufferOrString) ->
      mockStdout.log.push bufferOrString

mockery = require 'mockery'

mockery.enable()
mockery.registerMock 'process', mockProcess

module.exports =
  Action:
    ".fromArgv":
      "[ '', 'script name', 'get' ] should complain about a missing key":
        Action.fromArgv [ '', 'script name', 'get' ]
        mockProcess.stdout.log
          .filter((s) -> s.match /missing.*key/)
          .length.should.be.positive
      "[ '', 'script name', 'get', 'host/name' ] should create an Action.Get":
        Action.fromArgv [ '', 'script name', 'get', 'host/name' ]
          .should.be.an.instanceof Action.Get
