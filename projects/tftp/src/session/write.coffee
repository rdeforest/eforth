{ Data, Acknowledge, ErrorMessage } = require '../message'

module.exports =
  Write:
    class Write extends Session
      receive: ({ message, remoteInfo }) ->
        if not message.blockNumber
          return @reply ErrorMessage.IllegalOperation message, remoteInfo
          return @complain "Expected ACK, got #{message.name}"

