module.exports = (Array) ->
  { wrap } = require './wrap'

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

  wrap Array::, 'sort'    , after: markSorted
           .and 'pop'     , after: markUnsorted
           .and 'push'    , after: markUnsorted
           .and 'shift'   , after: markUnsorted
           .and 'splice'  , after: markUnsorted
           .and 'unshift' , after: markUnsorted

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
