Object.assign module.exports,
  Optional: (_value) ->
    _present = arguments.length > 0

    ret = (fn) ->
      if _present
        try
          return Optional fn _value

      return Optional()

    ret.then = ret

  Identity: (_value) -> _value

# Usage
#
#   result = fnReturningOptional
#     .then fnWhichMightThrow
#     .then Identity
#
# If the second call throws, result is 'undefined'. If you don't want to work
# with 'undefined', don't use Identity. :)
