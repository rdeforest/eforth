Spinner = require './spinner'

erase = null

displayStatus = (status) ->
  if erase
    console.log erase

  erase = ' '.repeat status.length
  erase = '\r' + erase + '\r'

  console.log status

spin = new Spinner show: displayStatus


