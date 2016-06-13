process = require 'process'
moment = require 'moment'

module.exports =
  progress: (opts, fn) ->
    if arguments.length < 2
      fn = opts
      opts = {}

    {out = process.stdout, interval = 2} = opts

    lastMsg = ""

    update = ->
      out.write "\r" + " ".repeat lastMsg.length
      out.write "\r" + (lastMsg = fn())

    anIntervalAgo = -> moment().subtract interval, 'seconds'
    lastUpdate = anIntervalAgo()

    (force) ->
      if force or lastUpdate.isBefore anIntervalAgo()
        update()
        out.write "\n" if force
        lastUpdate = moment()
