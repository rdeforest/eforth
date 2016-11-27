module.exports = (injectedRequire = require) ->
  require = injectedRequire

  class Message
    constructor: (@data) ->

    fromBuffer: (buffer) ->
      if not opClass = Message.opcodes[buffer[0]]
        opClass = Message

      return new opcode buffer

    stringAt: (offset) ->
      break for end in [offset..@data.length - 1] when @data[end] is 0

      Buffer.from @data, offset, end - offset

    int16At: (offset) -> @data[offset] * 256 + @data[offset + 1]

    @fromFields: (fields) -> Object.assign @, fields

    @opcodes:
      [ undefined, ReadRequest, WriteRequest, Data, Acknowledgement, Error ]

  class ReadWriteRequest extends Message
    constructor: (@data) ->
      @filename = @stringAt 2
      @mode = @stringAt (2 + @filename.length + 1)

  class ReadRequest extends ReadWriteRequest
  class WriteRequest extends ReadWriteRequest

  class Transmission extends Message
    constructor: (@data) ->
      @blockNumber = @int16At 2

  class Acknowledgement extends Transmission

  class Data extends Transmission
    constructor: (@data) ->
      super @data
      @payload = Buffer.from @data, 4

  class Error extends Message
    constructor: (@data, fields) ->
      if fields
        {@code, @message} = fields
      else
        @code = @int16At 2
        @message = @stringAt 4

      if @constructor is Error and codeClass = Error.codes[@code]
        return new codeClass @data, fields

    codes:
      1: EFileNotFound
      2: EAccessViolation
      3: EAllocationExceeded
      4: EIllegalOperation
      5: EUnknownTransferID
      6: EFileExists
      7: ENoSuchUser     #??? TFTP doesn't have users, what is this

