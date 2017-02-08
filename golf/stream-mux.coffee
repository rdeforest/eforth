#!/usr/local/bin/coffee

###

Names of streams of already-storted strings passed in on argv are merged and
written to stdout sorted.

###

fs = require 'fs'
{argv, stderr, stdout} = require 'process'
{Readable, Transform, Writable} = require 'stream'
{format} = require 'util'

logStream = fs.createWriteStream 'log'

log = (args...) -> false and stderr.write format(args...) + "\n"

class LineStreamMerger extends Readable
  constructor: (streams...) ->
    #console.log "LineStreamManager: ", streams
    #(require 'process').exit()

    switch streams.length
      when 0 then return new Readable read: -> null

      when 1 then return streams[0]

      when 2
        super objectMode: true

        [left, right] = streams
        @streams = @prepareStreams {left, right}

      else
        middle = streams.length >> 1
        left  = new @constructor streams[0..middle]...
        right = new @constructor streams[   middle + 1..]...

        return new @constructor left, right

  prepareStreams: (streams) ->
    for side, stream of streams
      nextRecord = null
      streamInfo = {side, stream, nextRecord}
      stream
        .on 'data', (record) => @receive streamInfo, record
        .on 'end', => @sideFinished streamInfo
        .resume()
      streamInfo

  receive: (streamInfo, record) ->
    if streamInfo.nextRecord
      throw new Error "Logic error: we already have a record for stream #{streamInfo.side}"

    streamInfo.nextRecord = record
    stream.pause()
    @mergeOne()

  sideFinished: (streamInfo) ->
    if (other = streams[0]) is streamInfo
      other = streams[1]

    if rec = streamInfo.nextRecord
      @push rec

    if not rec = other.nextRecord
      return # all done

    @push rec

    other
      .stream
      .pipe stdout
      .resume()

  pushOne: (streamInfo) ->
    {nextRecord, stream} = streamInfo

    @push nextRecord
    streamInfo.nextRecord = null
    
    stream.resume()

  _read: ->
    [a, b] = @streams

    unless a.nextRecord and b.nextRecord
      throw new Error "BUG: _read before ready"

    @pushOne (streams.sort (a, b) -> a.nextRecord.localeCompare b.nextRecord)[0]

class StreamToLines extends Transform
  constructor: (options = {}) ->
    super Object.assign {},
          options,
          readableObjectMode: true

    @pending = Buffer.from ''

  lineTerminator: '\n'

  _flush: (callback) ->
    callback null, @pending.toString @encoding

  _transform: (chunk, ignored, callback) ->
    chunk = Buffer.concat [@pending, chunk]
    from = 0
    
    while -1 < (idx = chunk.indexOf @lineTerminator)
      @push chunk.slice(from, idx).toString()
      from = idx + @lineTerminator.length

    @pending = chunk.slice from

    callback null

class LinePrinter extends Writable
  constructor: (outputStream) ->
    super objectMode: true

  _write: (line, encoding, callback) ->
    outputStream.write Buffer.from (line + "\n"), encoding

[coffee, script, files...] = argv

fs.createReadStream files[0]
  .pipe new StreamToLines
  .pipe new LineStreamMerger
  .pipe new LinePrinter

if false
  console.log (new LineStreamMerger (files.map (fName) ->
    (fs.createReadStream fName).pipe new StreamToLines
  )...)

# .pipe LinePrinter stdout

