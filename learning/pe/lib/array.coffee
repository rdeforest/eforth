{ wrap } = require './wrap'

DUPE_SCAN_CUTOFF = 100

hasDupe = (unsortedList) ->
  seen = new Set unsortedList[..DUPE_SCAN_CUTOFF - 1]

  if unsortedList.length <= DUPE_SCAN_CUTOFF
    return seen.length is unsortedList.length

  return false unless seen.length is DUPE_SCAN_CUTOFF

  for el in unsortedList[DUPE_SCAN_CUTOFF..]
    return false if seen.has el

    seen.add el

  true

sortedHasDupe = (sortedList) ->
  -1 < sortedList.findIndex (e, i, l) -> l[i+1] is e

setFlag = (name, clear)
  value = not clear

  (args...) ->
    ret = super args...
    ret[flag] = value
    ret

sorted = setFlag 'sorted'
unsorted = setFlag 'sorted', true

module.exports = (Array) ->
  Array::hasDupe = (sorted = @sorted) ->
    ( if isSorted
        sortedHasDupe
      else
        hasDupe
    ) @

  wrap Array, 'sort'     , after:   sorted
         .and 'pop'      , after: unsorted
         .and 'push'     , after: unsorted
         .and 'shift'    , after: unsorted
         .and 'splice'   , after: unsorted
         .and 'unshift'  , after: unsorted

