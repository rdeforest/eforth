alreadyHelped = false

{ stdout } = require 'process'

module.exports =
  class Help
    constructor: (@why...) ->

    start: ->
      unless alreadyHelped
        alreadyHelped = true

        stdout.write """
          To start a server:
            #{script}           < configOverrides.conf
     
          To fetch an object:
            #{script} get "host[:port]/key" > value

          To send an object:
            #{script} put "host[:port]/key" < value

          To see this text again:
            #{script} help
        """

        if @why.length
          stdout.write "\nYou were shown this help because:\n  "

      if @why.length
        stdout.write @why.join "\n  "

