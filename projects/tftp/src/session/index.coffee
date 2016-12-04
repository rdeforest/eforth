# A Session manages the state associated with a multi-message transmission.
# Message.Read receives a blob; Message.Write sends a blob.

conf = new (require '../config')

process = require 'process'

{ Data, Acknowledge, ErrorMessage } = require '../message'

module.exports =
  class Session
    @choosePort: ->
      { low, high } = conf.net.clientPort
      low + Math.floor(Math.random() * (high - low))

    constructor: (info = {}) ->
      { @key
        @buffer
        @retry = Consts.BindRetry
        @handshakeTimeout = Consts.HandshakeTimeout
      }

      if not @buffer
        throw new Error "Buffer parameter is required when constructing a Session."

      @lastACKdBlock = 0

    makeSocket: (@remotePort, @localPort = Session.choosePort()->
      new Promise (resolve, reject) =>
        @socket = dgram.createSocket conf.net.proto
          .on 'message',   @receive.bind @
          .on 'error',     reject
          .on 'listening', resolve

        @socket.bind @localPort

    # For when a server receives a request
    @fromMessage: ({ message, remoteInfo }) ->
      if klass = message?.newSessionClass
        return new klass.fromMessage { key: message.key, remoteInfo }
      else
        throw new Error "Session.fromMessage called with invalid message"

      @remotePort    = remoteInfo.port
      @remoteAddress = remoteInfo.address

    reply: (@lastSent) ->
      @resendLast()

    resendLast: ->
      @socket.send @lastSent.toBuffer(), @remotePort, @remoteAddress

class Read extends Session
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

class Write extends Session
  receive: ({ message, remoteInfo }) ->
    if not message.blockNumber
      return @reply ErrorMessage.IllegalOperation message, remoteInfo
      return @complain "Expected ACK, got #{message.name}"

Object.assign Session, { Read, Write }
