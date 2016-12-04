Message = require '.'

module.exports =
  ErrorMessage:
    class ErrorMessage extends Message
      name: "ERROR"

      constructor: (@subject, @remoteInfo) ->
        @codeNum = @constructor.codeNum

      fromBuffer: (@data) ->
        code = @int16At 2
        message = @stringAt 4

        if @constructor is ErrorMessage and codeClass = Error.codes[code]
          return new codeClass { code, message }

      toBuffer: ->
        Buffer.concat [
            Buffer.from [0, 5]
            Buffer.from [0, @codeNum]
            Buffer.from @errorMessage()
            Buffer.from [0]
          ]

      @codes:
        1: FileNotFound
        2: AccessViolation
        3: AllocationExceeded
        4: IllegalOperation
        5: UnknownTransferID
        6: FileExists
        7: NoSuchUser

# XXX: Something feels wrong about this...
class FileNotFound       extends ErrorMessage
class AccessViolation    extends ErrorMessage
class AllocationExceeded extends ErrorMessage
class IllegalOperation   extends ErrorMessage
class UnknownTransferID  extends ErrorMessage
class FileExists         extends ErrorMessage
class NoSuchUser         extends ErrorMessage

for codeNum, klass in ErrorMessage.codes
  ErrorMessage[klass.name] = klass
  klass.codeNum = codeNum
