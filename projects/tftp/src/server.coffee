dgram        = require 'dgram'
EventEmitter = require 'events'
process      = require 'process'

Session      = require './session'
Config       = require './config'
Logger       = require './log'
Message      = require './message'

log = new Logger

module.exports =
  class Server
    constructor: ->
      @sessions = {} # indexed by session.id
      @config = new Config

      log 'config = ' + JSON.stringify @config, 0, 2
      log '['

      process.on 'SIGINT', @shutdown.bind @

      @createSocket()

    log: (event) ->
      event.time = Date.now()

      log '  ' + JSON.stringify event + ","

    socketError: (err) ->
      @log { error: "socket error", err }

    serverStarted: ->
      @log { event: "server listening", port }

    messageReceived: (messageData, remoteInfo) =>
      try
        message = new Message messageData

        if session = new Session { message, remoteInfo }
          @addSession session
      catch error
        @log { error }

    createSocket: ->
      { type, port } = @config

      @socket = dgram.createSocket type
        .on 'message',   @messageReceived.bind @
        .on 'error',     @socketError.bind     @
        .on 'listening', @serverStarted.bind   @
        .bind port

    addSession: (session) ->
      if oldSession = @sessions[session.id]
        oldSession.end()

      @sessions[session.id] = session
