fs = require 'fs'
stream = require 'stream'
{argv, stdout} = require 'process'
[coffee, script, a, b] = argv

Zipper = require './coffee/stream-zipper'

class BufferToLines extends stream.Duplex
  constructor: ->
    super
    @lines = []

  _write: (chunk, encoding, callback) ->

  _read: (n) ->
    @push @lines.shift()


class JSONParseStream extends stream.Transform
  constructor: ->
    super objectMode: true

  _transform: (chunk, ignored, callback) ->
    callback null, JSON.parse chunk.toString()

class JSONEmitStream extends stream.Transform
  _transform: (object, ignored, callback) ->
    callback null, JSON.stringify object

aStream = fs.createReadStream(a).pipe new JSONParseStream
bStream = fs.createReadStream(b).pipe new JSONParseStream

#(
new Zipper aStream, bStream
  .pipe new JSONEmitStream
  .pipe stdout
#) .on 'close', process.exit()


