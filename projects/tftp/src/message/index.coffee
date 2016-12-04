{ ReadRequest, WriteRequest } = require './request'
{ Data, Acknowledgement }     = require './transmission'
{ ErrorMessage }              = require './error'

module.exports =
  class Message
    # Defined by RFC 1350
    @opcodes:
      [ undefined, ReadRequest, WriteRequest, Data, Acknowledgement, ErrorMessage ]

    constructor: -> # for creating new messages

    fromBuffer: (@data) -> # for wrapping received messages
      opCode = @int16At 0

      if not opClass = Message.opcodes[opCode]
        throw new Error "Unknown opCode #{opCode}"

      if @constructor isnt Message
        return opClass.fromBuffer @data

    int16At: (offset) -> @data.readInt16BE offset

    stringAt: (offset) ->
      break for end in [offset..@data.length - 1] when @data[end] is 0

      Buffer.from(@data, offset, end - offset).toString()

    toBuffer: -> @data

for opClass, opCode in Message.opcodes when opClass
  opClass.opCode = opCode
  Message[opClass.name] = opClass
