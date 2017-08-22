class SortedArray
  midIdx: ->
    idx = 1

    while @length > idx
      idx <<= 1 # I know there's a better way to do this...

    idx >> 1

  constructor: (@lt = (a, b) -> a < b, @cmp) ->
    elements = []

    if not @cmp
      @cmp = (a, b) =>
        switch
          when Number.isNaN a or Number.isNaN b then undefined
          when @lt a, b then -1
          when @lt b, a then  1
          else                0

  findInsertIndex: (element) ->
    if  not @length or
        1 is @cmp element, @elements[@length - 1]
      return @length

    while diff = @cmp @elements[idx], element
      if diff < 0
        idx -= half
      else
        idx += half

      break unless half >>= 1

    idx

  add: add = (element) ->
    if -1 is idx = @findInsertionIndexSorted sortFunction element
      @elements.push element

    else
      @elements.splice idx, 0, element

    return @

  push: add
  unshift: add

  remove: 
