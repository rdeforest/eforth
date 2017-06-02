Array::minus = (index) ->
  switch index
    when 0           then @[1..]
    when @length - 1 then @[..-2]
    else                  @[..index - 1].concat @[index + 1..]

firstDifference = (a, b) ->
  a.findIndex (x, i) -> x isnt b[i]

module.exports =
  areSimilar = (a, b) ->
    switch
      when -1 is i = firstDifference a,          b          then true
      when -1 is j = firstDifference a[i + 1..], b[i + 1..] then false
      when a[i] isnt b[j] or b[i] isnt a[j]                 then false
      else -1 is firstDifference a[j + 1..], b[j + 1...]
