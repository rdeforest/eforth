# Single use permission

module.exports = (fn, overUse) ->
  usedUp = overUse or -> throw new Error 'Attempt to re-use single-use permission'
  use = fn
  return (args...) ->
    use = usedUp
    fn args...

