#!/usr/local/bin/coffee

fs = require 'fs'
{argv, exit} = require 'process'

debug = (args...) -> false and console.log args...

class StreamBox
  constructor: (@fName) ->
    @buf = Buffer.from ''

    (@s = fs.createReadStream(@fName))
      .on 'end', =>
        debug "END: #{@fName}"
        @done = true
        streams.update @
      .on 'data', (more) =>
        debug "DATA: #{@fName}"
        @buf = Buffer.concat [@buf, more]
        streams.update @

  getLine: ->
    switch
      when -1 < (idx = @buf.indexOf '\n')
        [l, @buf] = [@buf.slice(0, idx).toString(), @buf.slice idx + 1]
      when @done and @buf
        [l, @buf] = [@buf.toString(), null]
      else
        debug "NOLINE #{@fName}"
        return
    return l

streams = argv[2..]
  .map (fName) -> new StreamBox fName

streams.update = (s) ->
  return unless s is streams[0]

  gotLine = true

  while streams.length and gotLine
    if gotLine = (s = streams.shift()).getLine()
      console.log gotLine

      if not s.buf
        debug "DONE: #{s}"
        continue
      
    if s.buf
      switch idx = (streams.findIndex ({buf: other}) -> (Buffer.compare s.buf, other) < 1)
        when -1
          streams.push s
        when 0
          streams.unshift s
        else
          debug "INSERT: #{idx}\nSTREAMS: #{streams}"
          streams.splice idx, 0, s
