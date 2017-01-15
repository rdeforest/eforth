It starts from CoffeeScript for brevity.

It adds the ability to apply constraints to parameters:

```coffee
    exampleFn = (SomeClass(details) paramaterName = default)  ->
      ...

    exampleResult = exampleFn someValue
```

If **SomeClass.validateParameter(someValue, details)** is false, the
invocation throws an error.

