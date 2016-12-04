Transfer = require './transfer'
{ Read } = require '../session'

module.exports =
  class Get extends Transfer
    @sessionClass = Read
