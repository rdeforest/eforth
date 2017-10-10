###

Usage:

  wrap obj, method, wrappage

'wrappage' is an object with zero or more of these keys:
  before: a method (        args...) -> adjusted args
  after:  a method (result, args...) -> adjusted result

###

module.exports.wrap =
wrap =
(obj, method, {before, after}) ->
  chain       = and: (method, what) -> wrap obj, method, what

  addBefore   = 'function' is typeof before
  addAfter    = 'function' is typeof after

  unwrapped   = obj[method]

  obj[method] =
    switch
      when addBefore and addAfter then (args...) -> after unwrapped (before args...)...
      when addBefore              then (args...) ->       unwrapped (before args...)...
      when               addAfter then (args...) -> after unwrapped         args...
      else                             (args...) ->       unwrapped         args...

  chain
