Message = require '.'

module.exports =
  Transmission:
    class Transmission extends Message
      name: "Abstract session message?!"

      constructor: (@blockNumber, @remoteInfo, @payLoad) ->
        @opCode = @constructor.opCode

        @data = Buffer.allocUnsafe @payLoad.length + 4
        @data.writeInt16BE @opCode, 0
        @data.writeInt16BE @blockNumber, 2
        @payLoad.copy @data, 4

      fromBuffer: (@data) ->
        @blockNumber = @int16At 2
        @payload     = Buffer.from @data, 4
        @lastBlock   = @payload.length < 512

  Acknowledgement:
    class Acknowledgement extends Transmission
      name: "ACK"

      fromData: (dataMessage) ->
        { @blockNumber, @remoteInfo } = dataMessage

  Data:
    class Data extends Transmission
      name: "DATA"


