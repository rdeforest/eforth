module.exports = (Array) ->
  UnsortedArrayPrototype = Array::

  (Array::) = Object.create UnsortedArrayPrototype

  DUPE_SCAN_CUTOFF = 100

  hasDupe = (markUnsortedList) ->
    seen = new Set markUnsortedList[..DUPE_SCAN_CUTOFF - 1]

    if markUnsortedList.length <= DUPE_SCAN_CUTOFF
      return seen.length is markUnsortedList.length

    return false unless seen.length is DUPE_SCAN_CUTOFF

    for el in markUnsortedList[DUPE_SCAN_CUTOFF..]
      return false if seen.has el

      seen.add el

    true

  markSortedHasDupe = (sortedList) ->
    -1 < markSortedList.findIndex (e, i, l) -> l[i+1] is e

  flagSetter = (name, value) ->
    (ret) -> Object.assign ret, "#{name}": value

  markSorted   = flagSetter 'sorted', true
  markUnsorted = flagSetter 'sorted', false

  Array::hasDupe = (sorted = @sorted) ->
    ( if @isSorted
        markSortedHasDupe
      else
        hasDupe
    ) @

  wrappedMutator = (args...) -> markUnsorted super args...

  stringCompare = (a, b) ->
    switch
      when a  < b then -1
      when a  > b then  1
      else              0

  Object.assign Array::,
    sort:    (comparator = @sortWith) ->
      @sortWith = comparator ? stringCompare
      markSorted super.sort arguments...

    pop:     wrappedMutator
    push:    wrappedMutator
    shift:   wrappedMutator
    splice:  wrappedMutator
    unshift: wrappedMutator

    insert: (value) ->
      cmp = @sortWith or 
      idx = (@length - 1) >> 1
      dist = idx >> 1

      if not @length or cmp value, @[@length - 1] < 0
        return markSorted @push v

      if cmp value, @[0] >= 0
        return markSorted @unshift value

      while dist and diff = cmp value, @[idx]
        if cmp > 0
          idx -= dist
        else
          idx += dist

        dist >> 1

      markSorted @splice idx, 0, value

  Array::cmp = (other) ->
    if  @length and other.length
       (@[0]     -  other[0]) or
        @[1..] .cmp other[1..]
    else
        @length  -  other.length


  Array::find = (cmp) ->
    return undefined unless @length

    switch cmp @[midx = @length >> 1]
      when -1 then midx + @[  midx..  ].find cmp
      when  1 then midx - @[..midx - 1].find cmp
      else midx


  # What about a decorated Array instead...

  class SortedArray extends Proxy
    @overrides:
      sort: -> ...
      # etc

    @handlers:
      set: (target, property, value, receiver) ->
        if 'number' is typeof property and 0 <= property
          insertInto target, value
          return value
        else
          target[property] = value

      get: (target, property, receiver) ->
        if 'number'   isnt typeof property and
           'function' is   typeof fn = SortedArray.overrides[property]
          fn
        else
          target[property]

    constructor: (@target) ->
      super @target, SortedArray.handlers

  keepSorted = (target, sortBy = stringCompare) ->
    sorted = new SortedArray target




