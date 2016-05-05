module.exports =
  _: _ = require 'underscore'

  process: process = require 'process'
  stdout: stdout = process.stdout
  stderr: stderr = process.stderr

  write: write = (stream, args) -> stream.write args.join(' ') + '\n'
  echo: echo = (args...) -> write stdout, args
  warn: warn = (args...) -> write stderr, args

  error: error = (exitStatus, args...) ->
    if not args.length
      throw new Error 'cmdutils#error called with insufficent args'

    write stderr, args
    process.exit exitStatus

  config: config = (require './config')()

  render: (format, data) ->
    switch format

      when 'shell'
        if 'object' isnt typeof data
          data.toString()
        else
          lines = []

          for k, v of data
            lines.push k.toString() + '=' + v.toString()

          lines.join '\n'

      when 'json'
        JSON.stringify data

      when 'json-pretty'
        JSON.stringify data, null, 2

      else
        error "unreconized render format: #{format}"
