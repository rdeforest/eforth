#!/usr/local/bin/coffee

###

inputs are streams of already-storted strings. They should be merged in sorted
order and written to stdout.

###

fs = require 'fs'
{argv, stderr} = require 'process'
{Readable} = require 'stream'
{format} = require 'util'

logStream = fs.createWriteStream 'log'

log = (args...) -> false and stderr.write format(args...) + "\n"

class SortableStream
  constructor: (fileName) ->
    @bufferStream = fs.createReadStream fileName
    @buffer = Buffer.from ""
    @lines = []
    @done = false
    @ready = false

    @bufferStream
      .on 'data', (d) -> @receive d
      .on 'finish', ->
        @lines.push @buffer.toString()
        @buffer = null

  receive: (d) ->
    @buffer = Buffer.concat [@buffer, d]
    seen = 0

    loop
      if -1 is idx = @buffer.indexOf '\n', seen
        @ready = @lines.length > 0
        return @buffer = @buffer.splice seen

      @lines.push @buffer.splice seen, idx - seen
      seen = idx + 1

  getOne: ->
    one    = @lines.shift()
    @ready = @lines.length > 0
    @done  = @buffer is null and not @ready

    return one

  cmp: (other) ->
    return other if not @ready()
    return @     if not other.ready()

    @lines[0].localeCompare other.lines[0]

class SortedStreamMerger extends Readable
  constructor: (@a, @b) ->
    @pending = a: null, b: null
    @merged  = null

    receive = (which) ->
      (d) ->
        @[which].pause()
        @pending[which] = d
        @maybeMerge()

    @a.on 'data', receive 'a'
    @b.on 'data', receive 'b'

  maybeMerge: ->
    if @pending.a and @pending.b and not @merged
      if a.cmp(b) > 0
        @merge 'b'
      else
        @merge 'a'

  merge: (which) ->
    @emit 'readable'
    @merged = @pending[which]
    @pending[which] = null
    @[which].unpause()

  _read: ->
    @push @merged
    @merged = null

combine = (streams) ->
  switch streams.length
    when 1 then streams[0]
    when 2 then new SortedStreamMerger streams...
    else
      middle = Math.ceil streams.length / 2
      new SortedStreamManager combine(streams[..middle - 1]), combine(streams[middle..])

[coffee, script, files...] = argv

streams = null

maybeMerge ->
  while (least = streams.reduce((a,b) -> a.cmp b)).length
    console.log least.getOne()

    if least.done
      streams = streams.filter (s) -> not s.done()

      if not streams.length
        return

streams = (new SortableStream f for f in files)
