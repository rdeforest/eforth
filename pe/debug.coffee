class Debug
  constructor: (@interval) ->
    @lastMsg = 0

  update: (msg...) ->
    if (Date.now() - @lastMsg) > @interval
      @report msg...
  
  report: (msg...) ->
    @lastMsg = Date.now()
    console.log msg...

module.exports = Debug
