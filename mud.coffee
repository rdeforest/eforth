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

defaultKey = Symbol 'default key'

MOP.enhance (
  class Session
    @has: [ Protocol, Connection ]

  class SessionReceiver
    @isA: [ Aspect ]
    @has: [ [ Session ] ]

  # Privileged message
  class OperationRequest
    @isA: [ Owned ]
    @has: [ name: 'string', sender: Object, definer: Object, args: Array ]

  class Permission
    @has: [ owners      : 'function'
            senders     : 'function'
            targets     : 'function'
            messageName : 'any'      ]

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
    @has: [ Owner, { operations } ]

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
    @composedOf: [ Player, SessionReceiver ]

  class UserDB
    @isA: [ Dictionary.of(User, (u) -> u.name) ]

  class Dictionary
    @of: ({@klass, keys}) ->
      @addKey key for key in keys

    constructor: ->
      @keys = {}
      @indexes = {}
      @values = []
      @dbTop = 0

    addKey: (keyInfo) ->
      if 'string' is typeof keyInfo
        key = {}
        key[defaultKey] = keyInfo
        keyInfo = key

      for name, key of keyInfo
        if @keys[name]
          if name is defaultKey
            throw new Error "Already have a default key"
          else
            throw new Error "Already have a key named #{name}"

        keyFn =
          switch typeof key
            when 'string'   then (o) -> o[key]
            when 'function' then key
            else
              throw new Error "Unknown key type"

        @keys[name] = key

      @reindex name

    lookupExact: (keyValue, keyName = defaultKey) ->
      if not index = @indexes[keyName]
        throw new Error "No such key"

      if not found = index[keyValue]
        throw new Error "Key value not found in index"

      return found

    reindex: (keyName) ->
      key = @keys[keyName]
      @indexes[keyName] = {}

      for v, id in @values
        @indexes[key v] = { id, v }
)
