###

COP = ColdMUD Object Protocol

COP objects only public members are methods and even those are wrappers which
enforce the COP method semantics. Methods run in their own sandboxes which are
reset on each invocation. COP objects can only be mutated by themselves or
an owner. Etc.

Protocol operations

- Object mutation
  - add/update/list/remove method(s)
  - add/update/list/remove fields(s)
- Method invocation
  - sandbox construction
    - fields, vars, globals
  - stack frame life cycle

About the method context (sandbox)

- its globals are not the Node globals
  - Object and Reflect are stripped down
    - setPrototypeOf doesn't exist
  - require() doesn't exist
  - etc
- custom COP globals
  - global functions
    - $foo are read-only methods and vars like $sender, $caller, $definer, $this
  - global objects
    - are all wrapped so that invoking methods on them maintains the stack frames
    - $root, $sys are like the ones in ColdMUD
- the context object's prototype is the instance's field dictionary
  - changes are detected by comparing the sandbox to its prototype
  - __proto__ and getPrototypeOf are disabled so no way to trick the system

###







###
#
# A previous attempt...

  COP.methodsOf = (o) -> o.methods
  COP.parentsOf = (o) -> o.parents

  COP.getParentInstance = (o, p) ->
    if o is p or o.constructor is p
      return o

    for a in COP.parentsOf o
      if found = COP.getParentInstance a, p
        return found

  COP.ancestorData = (o, p) ->
    ancestor = @getParentInstance o, p
    ancestor.data

  COP.dataOf = (o) ->
    data = {}

    for p in COP.ancestors o
      data[p.name] = COP.ancestorData o, p

    data

  COP.getMethod = (o, methodName) ->
    if Object.hasOwnProperty o.methods, methodName
      return o.methods[methodName]

  COP.findMethod = (receiver, methodName) ->
    if found = COP.getMethod receiver, methodName
      return found

    for p in COP.parentsOf receiver
      if found = COP.findMethod p, methodName
        return found

    throw new ColdError.methodnf receiver: receiver, methodName: methodName

###
###

This also doesn't take into account the distinction between data and methods.

So, data! Each parent then is also an instance:

###

###
    class Foo
      constructor: (info) ->
        {fooData} = info
        @data = foo: fooData

    class Bar
      constructor: (info) ->
        {barData} = info
        @data = bar: barData

    class ChildOfFooAndBar
      constructor: (info) ->
        @parents = Foo: new Foo info, Bar: new Bar info
        {childData} = info
        @data = child: childData

###
