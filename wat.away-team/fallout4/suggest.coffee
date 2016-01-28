#!/usr/bin/env coffee

Hack = require './simple'

allInput = (inStream) ->
  new Promise (resolve, reject) ->
    buffer = ""

    inStream
      .on 'data', (d) -> buffer += d.toString 'utf-8'
      .on 'end', -> resolve buffer
      .resume()

formatPick = (pick, remainder) ->
  s = "#{pick}\n"
  for dist in Object.keys(remainder).sort()
    s += "  #{dist} " + remainder[dist].join ' '
    s += "\n"
  s

allInput process.stdin
  .then (buffer) ->
    words = buffer
      .split /[\n\s]+/
      .filter (w) -> w.length

    for pick, remainder of Hack.best words
      console.log formatPick pick, remainder

  .catch (err) ->
    console.log "Oh no!\n" + err.toString()
