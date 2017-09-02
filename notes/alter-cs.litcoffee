    CoffeeScript = require 'coffee-script'

What if I came up with tools for either generating CoffeeScript code via macros or altering ASTs...

# Altering ASTs

    codeToAST = CoffeeScript.nodes.bind CoffeeScript

    class NodeVisitor
      constructor: (info) ->
        { @names = allNodeNames()
          @matcher = -> true
          @mutator = (node) -> node
        } = info

      traverse: (ast) ->
        ast.traverseChildren yes,
          (child) ->
            if @names and (name = child.constructor.name) isnt in @names
              return

## Motivating examples

    callWrapper = new NodeVisitor
      names: ''.split ' '

"""
    a = @method()
    b = fn()
    @method()
    fn()
"""
