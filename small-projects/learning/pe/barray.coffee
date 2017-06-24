# TODO:
#  - split each section into its own file
#  - tests!
#    - Especially fence post errors
insertSorted = (l, value, cmp = (a, b) -> a - b) ->
  insertAt = l.findIndex (e) -> (cmp value, e) <= 0

  insertAt = l.length if insertAt is -1

  l.splice insertAt, 0, value



























class BooleanArray
  constructor: (@value = true, @from = 0, @to = @from) ->

  get: (idx) ->
    if @from <= idx <= @to
      @_value idx
    else
      not @_value idx

  _value: (idx) -> @value

  toggle: (idx) ->
    throw new Error 'BooleanArray cannot toggle'

BooleanArray.spawn = (actualClass, args...) ->
  spawned = Object.create actualClass
  ret = actualClass.constructor.apply spawned, args

  if 'object' is typeof ret
    spawned = ret

  return spawned











class GrowingBooleanArray extends BooleanArray
  _extendUp: (@to) ->
  _extendDown: (@from) ->

  extendUp: (to) ->
    if @to < to
      @_extendUp @to, to

  extendDown: (from) ->
    if from < @from
      @_extendDown @from, from

  get: (idx) ->
    @extendDown idx
    @extendUp idx
    @value













# 'new CBA foo' creates a CBA from foo
class ClassyBooleanArray extends GrowingBooleanArray
  constructor: (value, from, to) ->
    if value instanceof BooleanArray
      super value.value
      @initFrom value

    else
      super value, from, to

  initFrom: (old) ->
    @value = old.value

    for idx in [from..@to]
      if old.get idx isnt @value
        @toggle idx


















class ExceptionalBooleanArray extends ClassyBooleanArray
  constructor: (@value = true, @from = 0, @to = @from) ->
    @exceptions = []

  canImprive: (subject) -> true

  _value: (idx) ->
    if idx in @exception
      not @value
    else
      @value

  toggle: (idx) ->
    if whence = @exceptions.indexOf idx
      @exceptions.splice whence, 1
    else
      insertSorted @exceptions, idx

    return this














class MorphingExceptionalBooleanArray extends ExceptionalBooleanArray
  constructor: (args...) ->
    super args...

    @maxExceptions = (@to - @from >> 2) + 2

  toggle: (idx) ->
    super idx

    if @exceptions.length > @maxExceptions
      return this = new DualBooleanArray this






















class DualBooleanArray extends ClassyBooleanArray
  constructor: (args...) ->
    super args...

    @middle = Math.floor (@to - @from) / 2 + @from

    @low  = new MorphingExceptionalBooleanArray @from, @middle
    @high = new MorphingExceptionalBooleanArray @middle, @to

  _reJigger: ->
    middle = Math.floor (@to - @from) / 2 + @from

    if middle isnt @middle
      return this = new DualBooleanArray this

  _extendDown: (@from) ->
    @low._extendDown @from
    @reJigger()

  _extendUp: (@to) ->
    @high._extendUp @to
    @reJigger()

  get: (idx) ->
    super idx # for auto-extend

    if idx < @middle
      @low.get idx
    else
      @high.get idx

  toggle: (idx) ->
    if idx <= @low.to
      @low._toggle idx
    else
      @high._toggle idx


















