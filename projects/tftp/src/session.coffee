module.exports = (injectedRequire = require) ->
  require = injectedRequire

  Message = require './message'

  class Session
    constructor: ({ message, remoteInfo }) ->

    receive: (message) ->

    send: (message) ->
