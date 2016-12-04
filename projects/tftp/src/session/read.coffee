Session = require '.'

{ ReadRequest, Data, Acknowledge, ErrorMessage } = require '../message'

module.exports =
  Read:
    class Read extends Session
      start: ->
        readRequest = new ReadRequest {
            remoteInfo
            @key
          }

        @socket.send readRequest

      receive: ({ message, remoteInfo }) ->
        switch
          when message not instanceof Data
            @reply new ErrorMessage.IllegalOperation message, remoteInfo

          when remoteInfo.port isnt @remotePort
            @reply new ErrorMessage.UnknownTransferID message, remoteInfo

          when message.blockNumber isnt @lastACKdBlock + 1
            @resendLast()

          else
            @lastACKdBlock++
            offset = message.blockNumber * 512 # defined by RFC 1350
            message.payload.copy @buffer, offset
            @reply Acknowledgement.fromData message, remoteInfo
