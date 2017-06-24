deepCopy = require './deepcopy'

module.exports = ->
  vm = require 'vm'

  ourGlobal = deepCopy global

  sending = {}

  sent = null

  outside =
    send: (data) -> sent = data
    receive: -> sending

  sandbox = vm.createContext outside: outside

  ourEval = (code) ->
    vm.runInNewContext code,
      filename: "sandbox"
      displayErrors: true

  ourSend = (data) ->
    sending = data

  return eval: ourEval, send: ourSend

