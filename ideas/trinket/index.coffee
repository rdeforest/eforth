module.exports =
  usage: usage = new Error """
    Usage:

    (require 'trinket')
      .create
        name: "Example"
        domain: "example.com"
        ...
  """

  create:
    CreateTrinket = (callerExports, info) ->
      throw usage unless info

      { name            = throw usage
        domain          = throw usage
        version         = throw usage
        implementation  = throw usage

        dependencies    = {}
        constants       = {}
        parameters      = {}
      } = info

      trinket = callerExports[name] =
        Object.assign functionFromImplementation implementation,
            { name
              domain
              version
              dependencies
              constants
              parameters
            }

      CreateTrinket # for chaining
        
