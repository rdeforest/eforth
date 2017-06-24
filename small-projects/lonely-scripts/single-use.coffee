# Single use function

module.exports = (fn) ->
  usable = true

  (args...) ->
    if usable
      usable = false
      fn args...
    else
      throw new Error 'Attempt to re-use single-use function'


