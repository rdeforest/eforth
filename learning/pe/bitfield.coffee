###

Efficient (read and write) storage of an array of true/false values

...

[
  before
  from
  value
  to
  after
]

class RangeMap
  constructor: (@before, @from, @value, @to, @after) ->
    [@before, @value, @after] =
      for f in [@before, @value, @after]
        if typeof f is 'function'
          f
        else
          -> f

  lookup: (n) ->
    return @before n if n < @from
    return @after  n if n > @to
    return @value  n

  set: (n, value) ->
    if n < @from
      @before = new RangeMap @before, n, value, n, @before

###

class BitField
  constructor: (@default = false) ->
    @toggled = {}

  set: (n) ->
    @toggled[n] = not @default

  clear: (n) ->
    @toggled[n] =     @default

  test: (n) ->
    if @toggled[n] then not @default else @default


