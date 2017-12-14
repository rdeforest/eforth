
suite 'Namespace', (suite, test) ->
  root = new Namespace 'root'
  root.set 'testing', foo, bar
  assert.equal root::foo::bar, 'testing'

exports = ({assert, suite, test} = {}) ->

exports require '.' if require.main is module
