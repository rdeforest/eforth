# Thinking about improving the DSL aspects of this stuff

## Format options

- verb subject, details
- meta(subject).verb details
- subject[meta].verb details
- META verb: object, details
- META.verb objectName: details

Examples

    cs = require 'coffeescript'

    makeVerb = (name, def) ->
      # This should define a function 'name' whose implementation is defined
      # by 'def'
      cs.eval """
        #{name} = (subject, details) ->
          def #{name}: {subject, details}
      """


