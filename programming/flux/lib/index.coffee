Object.assign module.exports,
  require './dispatcher'
  require './event'
  require './worker'
  require './counterWorker'

  test: ->
    global.d = new module.exports.Dispatcher

    global.cworker = new module.exports.CounterWorker d
