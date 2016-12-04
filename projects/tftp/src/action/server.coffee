Action = require '.'
Server = require '../server'

module.exports =
  class Server extends Action
    @sessionClass = Server
