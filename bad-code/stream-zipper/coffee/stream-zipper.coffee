stream = require 'stream'
{stderr} = require 'process'

module.exports =
  class StreamZipper extends stream.Readable
    constructor: (@a, @b) ->
      super objectMode: true
      @abuf = []
      @bbuf = []

      @a.on 'data', (d) ->
        @abuf.push d.toString()
        @emit 'data' if @bbuf.length

      @b.on 'data', (d) ->
        @bbuf.push d.toString()
        @emit 'data' if @abuf.length

    _read: ->
      while @abuf.length and @bbuf.length
        @push pushed = [@a.shift(), @b.shift()]
        stderr.write "DEBUG: " + JSON.stringify(pushed) + "\n"
