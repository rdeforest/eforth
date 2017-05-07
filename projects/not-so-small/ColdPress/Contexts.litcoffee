Since we're creating an Object Oriented programming system within another
Object Oriented programming system, it's easy to get confused about what kind
of object, method, etc we're talking about. To help with this we're naming the
contexts:

# The Matrix

The insides of apps written on top of ColdPress are The Matrix. Objects in the
apps are vertices, references are edges, etc. This is where the ColdPress
Object Protocol is used but not directly exposed.

# The Substrate

The ColdPress API as experienced by apps built on it is the Substrate. Objects
are (building) blocks, references are glue, etc. This is where the ColdPress
Object Protocol is exposed.

# Under the Hood (UtH)

The CoffeeScript and such which implement The Substrate are "Under the Hood"
and use normal terms such as Object and Method. This is where the ColdPress
Object Protocol is implemented.

## Module pattern

All UtH modules start with

    module.exports = ({imports}) ->

Where 'imports' is actually a list of functions this module depends on. If any
of the dependencies are unavailable the function will return an object whose
members are all 'undefined', the names of which identify the dependencies
which were missing.

      if not imports then return {imports}

The success return value of the function is an object whose members are the
actual exports. It may also be a Promise which resolves to the exports.

      new Promise (resolve, reject) ->
        # reference 'imports'
        resolve {realExports}

The module loader will wrap the return value in a Promise.resolve() so that it
is fine if it's not a Promise.
