# A Session manages the state associated with a multi-message transmission.
# Message.Read receives a blob; Message.Write sends a blob.

conf = new (require '../config')

module.exports =
  class Session
    @choosePort: ->
      { low, high } = conf.net.clientPort
      low + Math.floor(Math.random() * (high - low))

    constructor: (info = {}) ->
      { @key
        @buffer
        @remoteInfo
        @opts = conf.net.session
      } = info

      if not @buffer
        throw new Error "Buffer parameter is required when constructing a Session."

      @lastACKdBlock = 0

      @makeSocket()
        .then => @start()

    makeSocket: ->
      new Promise (resolve, reject) =>
        @socket = dgram.createSocket conf.net.proto
          .on 'message',   @receive.bind @
          .on 'error',     reject
          .on 'listening', resolve

        @socket.bind @localPort = Session.choosePort()

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

Object.assign Session,
  require './read'
  require './write'
