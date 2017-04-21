Here's how one would compose a namespace...

    define = require './nsdef'

    myBar = undefined

    imports =

imports.foo is equivalent to imports.commonjs.foo

      underscore:         '_'
      commonjs:
        jquery:           '$'

If the value of a leaf is a true boolean, the module's alias is its converted
name.

      backbone:         yes
      "coffee-script":  true

If a root key other than 'commonjs' has an object value, paths are taken as
nsRequire paths. The following would load example.foo.bar:

      example:
        foo: bar:    (barMod) -> myBar = barMod

Having captured all our dependencies (without version information, sadly), we
can now provide nsRequire with a function which will generate a singleton
constituting this module's exports.

    define {imports, module}, (imports) ->
      {_, $, Backbone, CoffeeScript} = imports

      class Example
        constructor: ->
          @imported = imports

      return {Example}

In this example the module's generator returned
  Example: Example

Which is equivalent to
  module.exports.Example = Example

If the generator returns something that either isn't an object or has no keys
of its own, definition() will leave module.exports alone under the assumption
that the module itself took care of the requisite mainpulations.
