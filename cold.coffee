###

Trying to think of the ColdMUD object model in terms of containment.

A child delegates to its parents, so ignoring the disallow_overrides mechanism
it's like the method lookup goes

###

  MOP.methodsOf = (o) -> o.methods
  MOP.parentsOf = (o) -> o.parents

  MOP.getParentInstance = (o, p) ->
    if o is p or o.constructor is p
      return o

    for a in MOP.parentsOf o
      if found = MOP.getParentInstance a, p
        return found

  MOP.ancestorData = (o, p) ->
    ancestor = @getParentInstance o, p
    ancestor.data

  MOP.dataOf = (o) ->
    data = {}

    for p in MOP.ancestors o
      data[p.name] = MOP.ancestorData o, p

    data

  MOP.getMethod = (o, methodName) ->
    if Object.hasOwnProperty o.methods, methodName
      return o.methods[methodName]

  MOP.findMethod = (receiver, methodName) ->
    if found = MOP.getMethod receiver, methodName
      return found

    for p in MOP.parentsOf receiver
      if found = MOP.findMethod p, methodName
        return found

    throw new ColdError.methodnf receiver: receiver, methodName: methodName

###

This also doesn't take into account the distinction between data and methods.

So, data! Each parent then is also an instance:

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


