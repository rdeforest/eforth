module.exports = ({argv}) ->
  handler = 'help'
  key = null

  [ coffee, script, action, key ] = argv

  switch action
    when 'get', 'put' then handler = action
    when undefined    then handler = 'server'
    else                   handler = 'help'

  return { script, handler, key }
