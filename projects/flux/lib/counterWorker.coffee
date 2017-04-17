{ReduceWorker} = require './worker'

module.exports.CounterWorker =
  class CounterWorker extends ReduceWorker
    getInitialState: -> 0

    reduce: (state, event) ->
      (@seen ||= []).push event
      switch event.name
        when 'inc' then state + 1
        when 'add' then state + event.data
        else            state


