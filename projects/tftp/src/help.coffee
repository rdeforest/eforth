alreadyHelped = false

module.exports =
  class Help
    constructor: ({stdout, script}) ->
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

