Array::findInsertionIndexSorted = (sortFunction, element) ->
  if not @length or 1 is sortFunction element, @[@length - 1]
    return @length

  mid = (@length >> 1) + 1

  if -1 < idx = @[0..mid - 1].findInsertionIndexSorted sortFunction, element
    idx
  else
    mid + @[mid..-2].findInsertionIndexSorted sortFunction, element

Array::sortedAdder (sortFunction) ->
  (element) ->
    if -1 is idx = @findInsertionIndexSorted sortFunction element
      @push element

    else
      @splice idx, 0, element

    return @

Array::addSorted (element, sortFunction) -> (@sortedAdder sortFunction) element
