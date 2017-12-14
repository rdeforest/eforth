{assert} = main = require '.'
exports = ({suite, test, done} = {}) ->
  suite __filename, (suite, test) ->
    AO = require '../lib/ao'


  done() if done

if require.main is module
  exports main
