exports = ({assert, suite, test, lib} = {}) ->
  suite 'AO', (suite, test, done) ->
    test 'throws without callback', ->
      assert.throws -> (lib '.')()

    test 'sets up AO', (done) ->
      (lib '.') (AO) ->
        test "something returned"     , -> assert       AO
        test "has a name"             , -> assert.equal typeof AO.name, 'string'
        test "with the right name"    , -> assert.equal AO.name, 'AO'
        test "and a prototype"        , -> assert       AO::
        test "and ::Namespace exists" , -> assert ns =  AO::Namespace
        test "and AO is one"          , -> assert       AO.constructor instanceof ns

        done()

    done()

  test "am I crazy", ->
    # maybe

exports require '.' if require.main is module
