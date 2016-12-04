###
{Command} = require '../'
env  = {}
argv = ['interpreter', 'path/to/I']

module.exports =
  install:
    ".findOrCreate should":
      "": ->

  command:
    ".identify":
      "with valid inputs should":
        "provide help in the absense of direction": ->
          result = Command.identify argv
          result.should.be.an.instanceof Command
          result.action.should.equal Command.actions.help

        "recognize":
          "-h and --help": ->
            Command.identify argv.concat '-h'
              .action.should.equal Command.actions.help

            Command.identify argv.concat '--help'
              .action.should.equal Command.actions.help


          "the verb 'am' as the doing action": ->
            Command.identify argv.concat 'am hungry'.split ' '
              .action.should.equal Command.actions.doing

          "the verb 'was' as the did action": ->
            Command.identify argv.concat 'was hungry an hour ago'.split ' '
              .action.should.equal Command.actions.did
###
