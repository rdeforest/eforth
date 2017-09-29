###

Usage:

  wrap obj, method, wrappage

'wrappage' is an object with zero or more of these keys:
  before: a method (        args...) -> adjusted args
  after:  a method (result, args...) -> adjusted result

###

module.exports.wrap = wrap = (obj, method, what) ->
  chain = and: (method, what) -> wrap obj, method, what

  {before, after} = what

  wrapped     = obj[method]

  wrapped     = wrapped (before args...)... if before
  wrapped     = after wrapped (       args   )... if after

  obj[method] = wrapped

  chain
