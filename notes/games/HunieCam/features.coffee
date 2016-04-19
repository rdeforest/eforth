# Extends a supplied object (String by default) to add padStart/right, padEnd/left and center


exportedFunctionRan = false

module.exports = extendString = (victim = String) ->
  exportedFunctionRan = true

  victim.fillWidth = pad = (width) -> (@repeat width).substr 0, width

  victim.padStart =
    right = (width, padStr = ' ') -> this + @pad width - @length

  victim.padEnd =
    left = (width, pad = ' ') ->
    (pad.fillWidth width - @length) + this

  victim.center = (width, pad = ' ') ->
    diff = width - @length
    middle = Math.floor diff / 2
    [ pad.fillWidth(middle), this, pad.fillWidth(diff - middle)].join ''

  victim.justify = {left, right}



# If the require() call doesn't invoke the returned function before the task
# yields or returns, assume it never will and call it by default.

setTimeout -> extendString() if not exportedFunctionRan
