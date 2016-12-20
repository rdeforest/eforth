# I want
#  - composition to be easier
#
# What would it be like to program a mud engine in CoffeeScript?

class User
  constructor: (@name, password) ->
    @email = null
    @saltedHashedPass = Crypto.saltedHash password

    @asOwner  = new OwningFacet @
    @asPlayer = new PlayerFacet @
    @asClient = new ClientFacet @

  validatePass: (cleartext) -> @saltedHashedPass.matches cleartext

  setEmail: (newEmail) ->
    if @email
      @notifyEmailChange newEmail

    @email = newEmail


# ...

MOP.enhance (
  class PlainTextByLines extends Protocol
    eventsToBuffer: (events) -> new Buffer
    bufferToEvents: (buf) -> []
    errorToEvent: (e) -> {}

  class Session
    @isA: [ EventEmitter ]

    @has: {
      Socket
    }

    @protocol: PlainTextByLines

    start: ->
      @protocol = @constuctor.protocol
      @socket
        .on 'close',   @socketClosed.bind @, 'close'
        .on 'end',     @socketClosed.bind @, 'end'
        .on 'data',    @receive.bind      @
        .on 'error',   @error.bind        @
        .on 'timeout', @timeout.bind      @

      
    setTimeout:     (milliseconds) -> @socket.setTimeout milliseconds
    socketClosed: (how, had_error) -> @emit 'end', {how, had_error}
    error:                     (e) -> @emit (@protocol.errorToEvent e)...
    shutdown:                      -> @socket.end()
    send:                 (events) -> @socket.write @protocol.eventsToBuffer events
    receive:              (buffer) -> (@emit event...) for event in @protocol.bufferToEvents buffer

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
      @write 

    processCommand: (line) ->
      line.replace /(^\s*)|(\s*$)/g, ''
      [firstWord, rest...] = line.split /\s+/

      switch firstWord
        when 'login', 'connect' then @login    rest...
        when 'register'         then @register rest...
        when 'send'             then @sendPass rest...
        else                         @help     rest...

  class SessionReceiver
    @isAn: [ Aspect ]
    @has:
      listeningOn: NetAddressInfo
      sessionClass: isa: constructorOf: Session
      server: Server

    start: ->
      @server = new Server
        .listen @listeningOn.port
        .on 'connection', @startSession.bind @

    startSession: (socket) -> new @sessionClass { socket }


  # Privileged message
  class OperationRequest
    @isA: [ Owned ]
    @has: { name: 'string', sender: Object, definer: Object, args: Array }

  class Permission
    @has:
      owners      : 'function'
      senders     : 'function'
      targets     : 'function'
      messageName : 'string'

    permitted: ({owner, sender, target, message}) ->
      @owners(owner) and
      @senders(sender) and
      @targets(target) and
      @messages(message)

  class AdminPermission
    @isa: [ Permission ]
    permitted: ({owner, sender, target, message}) ->
      return false unless Owner(owner).hasPermission @
      return false unless Owned(target).ownedBy owner

  class Owned
    @isAn: [ Aspect ]
    @has: { Owner, operations: [ Operation ] }

    withPermission: (operation) ->
      if @my.operations(operation)

  class Owner
    @isAn: [ Owned ]
    @has: [ [ Permission ] ]

  class User
    @has: [ Player ]

  class Player
    @isAn: [ Owned, Aspect ]
    @has: [ [ Avatar ] ]

  class User
    @isAn: [ Authenticated ]
    @composedOf: [ Player, SessionReceiver ]

  class UserDB
    @isA: [ Dictionary.of(User, (u) -> u.name) ]
)
