class PlainTextByLines extends Protocol
  eventsToBuffer: (events) -> new Buffer
  bufferToEvents: (buf) -> []
  errorToEvent: (e) -> {}

class Session extends EventEmitter
  constructor: (@socket) ->

  start: ->
    @socket
      .on 'close',   @socketClosed.bind @, 'close'
      .on 'end',     @socketClosed.bind @, 'end'
      .on 'timeout',      @timeout.bind @
      .on 'data',         @receive.bind @
      .on 'error',          @error.bind @

  setTimeout:     (milliseconds) -> @socket.setTimeout milliseconds
  socketClosed: (how, had_error) -> @emit 'end', {how, had_error}
  error:                     (e) -> @emit (@protocol.errorToEvent e)...
  shutdown:                      -> @socket.end()
  send:                 (events) -> @socket.write @protocol.eventsToBuffer events
  receive:              (buffer) -> (@emit event...) for event in @protocol.bufferToEvents buffer

class TelnetSession extends Session
  protocol: PlainTextByLines

class LoginProtocol extends Protocol
  bufferToEvents: (buffer) ->
    @buffer = Buffer.concat @buffer, buffer

    return unless lineLen = @buffer.contains NEW_LINE

    firstLine = @buffer.toString 'utf8', 0, lineLen
    @buffer = Buffer.from @buffer, lineLen
    @processCommand firstLine

  login: (name, pass) ->
    unless (user = @userDb.lookup name) and (user.chkPass pass)
      return Buffer.from "Invalid password or user name"

    return Buffer.from "Logging in..."

  register: (name, pass, email) ->
    @userDb.requestAccount name, pass, email, @
    @write ...

  processCommand: (line) ->
    line.replace /(^\s*)|(\s*$)/g, ''
    [firstWord, rest...] = line.split /\s+/

    switch firstWord
      when 'login', 'connect' then @login    rest...
      when 'register'         then @register rest...
      when 'send'             then @sendPass rest...
      else                         @help     rest...

class SessionReceiver
  constructor: (@sessionClass, @port, @address) ->

  start: ->
    @server = new Server
      .listen @listeningOn.port
      .on 'connection', @startSession.bind @

  startSession: (socket) -> new @sessionClass socket

class UserDB extends Dictionary
  constructor: (@db) ->
    @defaultKey 'name'
    @addKey 'email'

userDB = new UserDB './db'

class User
  constructor: (@name, @password, @email) ->
    if exists = userDB.lookup @name
  @composedOf: [ Player, SessionReceiver ]
