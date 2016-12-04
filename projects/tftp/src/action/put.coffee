Transfer  = require './transfer'
{ Write } = require '../session'

module.exports =
  class Put extends Transfer
    @sessionClass = Write

