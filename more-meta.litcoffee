One of the patterns which appeals to me is that of all aspects of a
programming language being accessible from within that language. For example,
I want the ability to introspect non-native functions as ASTs, kinda like
Lisp. I also want the ability to operate on variables as first-class objects
such that for example:

    example = (someArg) ->
      someVar = 'someString'

    console.log Relect.examineFunction example

would output something like

```txt
    { name: 'example',
      args: [ { name: 'someArg' } ],
      vars: [ { name: 'someVar' } ],
      ast: [ { op: 'Assign', dest: [Object] } ] }
```

The type of the value returned by examineFunction would be something like
Function.Structure. Its members would also be relevant classes so that (or
example) one could add args to a function with something like

    example.args.push Reflect.Argument 'someMore', slurp: true
    example.args.push Reflect.Argument
      deconstructor: Reflect.Argument.Deconstructor
        type: 'object'
        members: [ 'a', 'b' ]

And then...

    console.log Reflect.rebuildFunction(example).toString()

would output something like

```javascript
    function example(someArg, someMore..., {a, b}) {
      someVar = 'someString';
    }
```

# And what problem do you think you're solving, exactly?

A programming language is a tool for manipulating things on a computer. Code
is a thing on a computer. A good language could also be good at manipulating
itself. I shouldn't have to justify John McCarthy's work?

## Fine, invoke McCarthy. Do you have any use cases in mind?

Instead of edit/compile/run or edit/run, how about if it were just edit?

I don't even know what I'm talking about.
