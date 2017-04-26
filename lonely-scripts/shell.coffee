module.exports = (inStream = process.stdin) ->
  new Promise (resolve, reject) ->
    buffer = ""

    inStream
      .on 'data', (d) -> buffer += d.toString 'utf-8'
      .on 'end', -> resolve buffer
      .resume()

###

Usage:

  (require 'shell')(process.stdin)
    .catch (err) -> # if you care
    .then (lines) ->
      # do stuff with lines

###
