    module.exports = (opts) ->
      time: time = (fn) ->
        start = Date.now()

        try
          result = fn()
          {reply: result, elapsed: Date.now() - start}
        catch e
          e
