app   = require './app'
debug = require('debug')('pass-gas:server')
http  = require 'http'

class Port
  constructor: (@supplied) ->
    @value =
      switch
        when @isPipe = isNaN @portNum = parseInt @supplied, 10 then @supplied
        when @portNum >= 0 then @portNum
        else false

  toString: -> (if @isPipe then 'Pipe ' else 'Port ') + @value.toString()

  valueOf: -> @value

module.exports = ->
  onError = (error) ->
    throw error if error.syscall isnt 'listen'

    switch error.code
      when 'EACCES'
        console.error "#{port} requires elevated privileges"
        process.exit 1
      when 'EADDRINUSE'
        console.error "#{port} is already in use"
        process.exit 1
      else
        throw error

  onListening = ->
    addr = server.address()
    debug "Listening on #{port.toString().toLowerCase()}"

  port = new Port process.env.PORT || '3000'
  app.set 'port', port.valueOf()

  (server = http.createServer app)
    .on 'error'    , onError
    .on 'listening', onListening
    .listen app.get 'port'

