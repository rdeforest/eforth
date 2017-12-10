###

Some principles

- JavaScript methods are meta
- AO props and methods are accessed via instance.lookup, instance.dispatch, etc
- Methods added via ActiveObject::addMethod
  - are compiled to an AST and the following wrapped in AO goo:
    - object references
    - prop references
    - method calls

###

path = require 'path'

module.paths.unshift path.resolve __dirname, 'lib'

Object.assign module.exports,
  require 'object'
  require 'properties'
  require 'methods'
  require 'definer'

