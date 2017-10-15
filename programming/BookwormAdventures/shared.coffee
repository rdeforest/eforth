cs = require 'coffeescript'

module.exports = (moduleRequests...) ->
  { installHere = true
    installOn   = {}
    testing     = (->)
  } = module.exports

  requests = []

  for modules in moduleRequests
    modules = modules.split /\s+/ if 'string' is typeof modules

    if Array.isArray modules
      for name in modules
        requests[name] = name
    else
      Object.assign requests, modules

  reqStr =
    (name, mod) -> "#{name}: #{
      if module.exports.installHere
        "#{name} = "
      else
        ""} require '#{mod}'"

  testing requests
  testing requires = (reqStr name, mod for name, mod of requests)
  testing str = requires.join '\n'

  Object.assign installOn, cs.eval str unless module.exports.testing

