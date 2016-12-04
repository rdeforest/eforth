Message = require '.'

module.exports =
  ReadWriteRequest:
    class ReadWriteRequest extends Message
      name: "Abstract read-write request?!"

      constructor: (@data) ->
        @filename = @stringAt 2
        @mode = (@stringAt (2 + @filename.length + 1)).toLowerCase()

  ReadRequest:
    class ReadRequest extends ReadWriteRequest
      name: "RRQ"

  WriteRequest:
    class WriteRequest extends ReadWriteRequest
      name: "WRQ"

