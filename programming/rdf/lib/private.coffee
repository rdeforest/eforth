instanceData = new Map

module.exports.Private =
Private = (defaults = -> {}) ->
  if new.target
    throw new Error "Private function is not a class. See Private.comment for usage."

  instanceData.set sym = Symbol(), new Map

  if 'function' isnt typeof defaults
    defaults = -> defaults

  accessor = ->
    classData = instanceData.get sym

    unless data = classData.get @
      classData.set @, data = defaults()

    data

Private.makeGetter = (accessor, propName) ->
  -> accessor(@)[propName]

Private.addGetter = (obj, accessor, propName, getterName = propName) ->
  Object.defineProperty obj, getterName,
    get: Private.makeGetter accessor, propName

Private.makeSetter = (accessor, propName) ->
  (v) -> accessor(@)[propName] = v

Private.addSetter = (obj, accessor, propName, setterName = propName) ->
  Object.defineProperty obj, setterName,
    set: Private.makeSetter accessor, propName

Private.addGetterSetter = obj, accessor, propName, accessorName = propName)
  Object.defineProperty obj, accessorName,
    get: Private.makeGetter accessor, propName
    set: Private.makeSetter accessor, propName
  
Private.comment = """
    Private [defaults] creates an accessor function whose scope includes a
    Map<any, Map>. The inner Maps associate data with whatever 'this' is when
    the accessor is called. If the associated Map doesn't have the key then
    that key's value is set via the default function, or a function returning
    default if it's not a function already. The default 'default' (heh) is
    '-> {}'.

    The most common use case is for giving classes a place to store private
    data:

        p = Private()

        class Counter
          constructor: ->
            p().total = 0

          add: (n) -> p(@).total += n

        Object.defineProperty Counter::,
          get: -> p(@).total


        counter = new Counter
        counter.add 2
        counter.add 5
        console.log counter.total
        # => 7

    The point is that the 'total' value can only be modified by functions in
    scope of 'p'. Outside that scope, there is no non-debugging way to access
    'total'.

    Note that instances can access each other's data by calling the accessor
    with 'this' set to the other instance:

        a = new Counter
        b = new Counter

        b.getAData = -> p(a)

    If hiding is neither needed or wanted, but the independent namespace is,
    you can add the accessor to the class:

        myData = (self) -> Counter.p.call(self)

        class Counter extends SomeOtherClass
          @p: Private()

          constructor: ->
            super()
            myData(@).total = 0

          add: (n) -> myData(@).total += n

        Object.defineProperty Counter::, 'total'
          get: -> myData(@).total

    Don't put it on the prototype, because then you lose the namespace
    collision avoidance. If Counter::p is your accessor, a subclass of
    Counter can't have its own ::p because it will hide the one on its
    ancestor. That being said, there's not much point in using this library
    that way since you still have a private function ('myData' in the example)
    you're using to access the data.

    There are also properties on Private for creating and installing accessors
    on objects:

        Private.addGetter Counter::, Counter.p, 'total'

    This does the defineProperty for you. There are also:

        .addSetter
        .makeGetter
        .makeSetter
        .addGetterSetter
  """

