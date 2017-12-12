# RDF Module standard

Standard modules export a function which takes an optional options object. The
return value of that function is the exported module.

Exported modules have standard properties:

  * imports: module's dependencies
  * exports: module's exported functions
  * comment, usage: strings describing the module to humans
  * etc... (more to come)


## Example

```coffee

    # MyModule.coffee

    require 'rdf/lib/module'
      .defineModule
        comment: 'Example use of RDF module builder'

        defaults:
          options: install: true # exported values added to global or window
          imports: logger:  console

        # Return a module
        ({imports, options}) ->
          exports: imports

        # Prepare to return a module
        ({require, options}) ->
          # declare 'foo' as an injectable import
          require './string'

          # declare 'underscore' as an injectable import named '_'
          require _: 'underscore'

```
