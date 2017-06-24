# Some things I want in CoffeeScript

## .toBoolean()

In the following:

    if (foo) then bar

'foo' should be evaluated by something like the following:

    if 'function' is typeof foo?.toBoolean and
        t = try foo.toBoolean() and
        'boolean' is typeof t
      return t
    else
      return foo

## Autoboxing

When a primitive value (non object/function) is the target of a method call,
the call should go to its representative with 'this' set to that value. In
other words:

    foo.bar baz

becomes

    handler =
      if foo is null
        Object.represetative['null']
      else if (t = typeof foo) not in ['object', 'function']
        Object.representative[t]
      else
        foo.bar

    handler.apply foo, arguments

Where...

    Object.representative =
      null:
        toString: -> 'null'
        toBoolean: -> false
      # etc

## Macros (like Lisp) maybe?

Still figuring out what the point of them is, but so far it seems to be a way
to subvert scoping limitations. If so, maybe it's not such a good thing...

Using an example from
http://lists.warhead.org.uk/pipermail/iwe/2005-July/000130.html for
comparison.

    setSqrt = defMacro (place, v) ->
      quote ->
        setf comma(place), v * v

    sqrt = defsetf setSqrt

Supposedly this enables

    setf sqrt(x), 12

As another way to write

    x = 12 * 12

_Weird..._

One way to do this might be to not compile the CoffeeScript AST (.nodes
output) but instead to keep it around and evaluate it as it is encountered,
essentially mimicing Lisp.

We could start by enhancing Base to give it an 'eval' method and then have all
its children do the right thing. We'd also need to add a new node type for
things which need to be expanded and that's why we'll probably need new
syntax.

We might also prefer to create a new class which wraps children of Base.

    class AST
      constructor: (@nodes) ->

      eval: ->
        eval @nodes.compile {}, 0 # or something :P

### Potential syntax extensions

- Backslash for quoting

    \quoted_identifier
    \( quoted expression )

- `{[ ]} for quoted anything, `{[ ]} for de-quoting?

    defMacro xPlusY: (x, y) -> `{[ -> {[x]} + {[y]} ]}
    #`

  - barf

See also http://www.defmacro.org/ramblings/lisp.html


