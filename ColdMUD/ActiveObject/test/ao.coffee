{assert} = main = require '.'

exports = ({suite, test, done} = {}) ->
  suite __filename, (suite, test) ->
    test '', (done) ->
      (require '../lib') (AO) ->
        assert AO, "something returned"
        assert AO::, "it has a prototype"
        assert ns = AO::Namespace, "AO::Namespace exists"
        assert AO.constructor instanceof ns, "AO isA AO::Namespace"
        done()

  done() if done

if require.main is module
  exports main
