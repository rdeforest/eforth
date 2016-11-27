module.exports =
  class Listner
    constructor: ({ @dgram, @type, @Session, @config, @server }) ->
      @socket = @dgram.createSocket @type
      @socket.on 'message', (message, remoteInfo) ->
        if session = new Session { message, remoteInfo }
          @server.addSession session
