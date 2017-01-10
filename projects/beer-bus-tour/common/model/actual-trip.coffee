moment = require 'moment'

# An ActualTrip is a particular journey between two stops. Everything about it
# is captured in the events which reference it.
module.exports = ({make}) ->
  make 'ActualTrip',
    schema:
      vehicalId: String

