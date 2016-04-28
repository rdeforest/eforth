module.exports =
  _: _ = require 'underscore'

  process: process = require 'process'
  stdout: stdout = process.stdout
  stderr: stderr = process.stderr

  echo: echo = (args...) -> stdout.write args.join ' '
  warn: warn = (args...) -> stderr.write args.join ' '

  error: error = (exitStatus, args...) ->
    warn args...
    process.exit exitStatus

  config: config = require './config'

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
