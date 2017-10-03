path     = require 'path'
assert   = require 'assert'

{suite}  =
joe      = require 'joe'

suite 'Method wrapper', (suite, test) ->
  { wrap } = require path.resolve '..', '..', 'lib', 'wrap'

  test 'wraps instance method', ->
    happened = ''

    before = -> happened += 'b'
    after  = -> happened += 'a'

    class Foo
      method: -> happened += 'm'

    wrap Foo::, 'method', {before, after}

    foo = new Foo
    foo.method()

    assert.equal happened, 'bma'

  test 'finds and wraps inherited method', ->
    happened = ''

    before = -> happened += 'b'
    after  = -> happened += 'a'

    class Bar
      method: -> happened += 'm'

    class Foo extends Bar

    originalMethod = Bar::method

    foo = new Foo
    foo.method()

    wrap Foo::, 'method', {before, after}

    assert.equal happened, 'bma'

    assert.equal originalMethod, Bar::method


