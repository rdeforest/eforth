#!/usr/local/bin/coffee

fs = require 'fs'
{argv, exit} = require 'process'

debug = (args...) -> false and console.log args...

tree = null
spew = -> console.log l while l = tree.getLine()

class StreamBox
  constructor: (@fName) ->
    @buf = Buffer.from ''

    (@s = fs.createReadStream(@fName))
      .on 'end', => @done = true; spew()
      .on 'data', (more) =>
        @buf = Buffer.concat [@buf, more]; spew()

  getLine: ->
    switch
      when -1 < (idx = @buf.indexOf '\n')
        [l, @buf] = [@buf.slice(0, idx).toString(), @buf.slice idx + 1]; l
      when @done and @buf
        [l, @buf] = [@buf.toString(), null]; l

class Merger extends (require 'stream').Readable
  constructor: (@streams) ->
    return @streams[0] unless m = (l = @streams.length) >> 1
    super objectMode: true
    @lines = [null, null]
    unless l is 2
      @streams = [new Merger(@streams[..m]), new Merger(@streams[m + 1..])]

  least: ->
    if null in @lines then return
    if @lines[0] < @lines[1] then 0 else 1

  getLine: ->
    (@lines[i] = s.getLine()) for s, i in @streams when @lines[i] is null
    least = @least()
    return if least is undefined

    [l, @lines[least]] = [@lines[least], null]

    return l

tree = new Merger argv[2..].map (fName) -> new StreamBox fName
