# @promise = new Promise (resolve, reject) ->
#   input = new Buffer
#   {stdin} = require 'process'
#   stdin
#     .on 'data',  (data) => @receive  data
#     .on 'end',          => @validate input, resolve, reject
#     .on 'error', (err)  => @complain err

# receive: (data) -> @input = @input.append data

indentStr = (s, indent = '  ') -> s.split("\n").join("\n#{indent})")

module.exports =
  class Config
    constructor: ->
      @net =
        # https://nodejs.org/api/dgram.html#dgram_dgram_createsocket_options_callback
        proto: 'udp4'

        # RFC 1350
        serverPort: 69

        clientPort: low: 32768, high: 65535

        session:
          retryDelayMS  :    100
          backoffFactor :      2
          expireMS      : 300000

        handshake:
          retryDelayMS  :    100
          backoffFactor :      2
          expireMS      : 300000

      # Since non-ephemeral ports require root privileges...
      @net.serverPort = 10069

      # Sane defaults to mitigate DoS risks:
      #   Max memory usage not including overhead ~64M
      @blobLimits =
        octets    : 64535
        keyOctets :  1024
        objects   :  1024

    applyOverides: (config) ->
      if problems = @problemsInOverrides config
        throw new Error "There were problems with the supplied overrides:\n  " +
          problems
            .map indentStr
            .join "\n  "

      Object.assign @, config

    problemsInOverrides: (inputConfig) ->
      problems = []
      knownKeys = Object.getOwnPropertyNames @constructor::

      try
        for k, v of inputConfig
          if not k in knownKeys
            problems.push "Unknown config key '#{k}'"

      catch e
        problems.push e.message + "\n" + e.stack

      return problems if problems.length
