OBJECT_KEY_REGEX = /^([^:/]*)(:(\d+))?\/(.*)$/
MAX_SOCKET_BIND_ATTEMPTS = 10

process = require 'process'

parseKey = (key) ->
  matched = key.match OBJECT_KEY_REGEX

  if not matched
    throw new Error "Key does not match host[:port]/name"

  [ wholeKey, host, colon, port, name ] = matched

  return [ host, port, name ]

choosePort = ->
  Math.floor(Math.random() * (65535 - 1024) + 1024)

module.exports =
  class Session
    constructor: ({ key }) ->
      @retry = MAX_SOCKET_BIND_ATTEMPTS

      [ @host, @port = 69, @name ] =
        parseKey key

    makeSocket: ->
      @localPort = choosePort()
      @socket = dgram.createSocket 'udp4' # XXX: need to abstract 'udp4' out
        .on 'message', @receive.bind @
        .on 'error', =>
          if @retry--
            @makeSocket()
          else
        .on 'listening', =>

    # For when a server receives a request
    fromMessage: ({ message, remoteInfo }) ->
      if @constructor is Session
        if klass = message?.newSessionClass
          return klass.fromMessage { message, remoteInfo }
        else
          throw new Error "Session.fromMessage called with invalid message"

      @remotePort    = remoteInfo.port
      @remoteAddress = remoteInfo.address

    receive: (message) ->

    send: (message) ->

class Read extends Session
  fromMessage: ({ message, remoteInfo }) ->

class Write extends Session
  fromMessage: ({ message, remoteInfo }) ->

Object.assign Session, { Read, Write }
