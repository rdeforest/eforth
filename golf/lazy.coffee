# Lazy iteration

lazy = (fn) ->
  loop
    yield fn args...

