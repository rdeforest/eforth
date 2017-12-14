{assert} = main = require '.'

exports = ({suite, test} = {}) ->
  suite __filename, (suite, test, done) ->
    suite 'lib', (suite, test, done) ->
      (require '../lib') (AO) ->
        test "something returned"     -> assert       AO
        test "with the right name"    -> assert.equal AO.name, 'AO'
        test "and a prototype"        -> assert       AO::
        test "and ::Namespace exists" -> assert ns =  AO::Namespace
        test "and AO is one"          -> assert       AO.constructor instanceof ns
        done()

    done()

