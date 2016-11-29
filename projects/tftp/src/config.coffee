
# This module does too much, needs to be split into
#  - configuration as a concept
#    - defaults
#    - override with an object
#    - validation
#  - Reading JSON from a stream
#  - "complaint" feature

module.exports =
  class Config
    # Dependency injection for easier testing
    constructor: ({@help, @stdin, @log}) ->
      # https://nodejs.org/api/dgram.html#dgram_dgram_createsocket_options_callback
      @protocol                 = 'udp4'

      # RFC 1350
      @udpPort                  =    69

      # But non-ephemeral ports require root privileges
      @udpPort                  =  1069

      # Sane defaults to mitigate DoS risks
      @maximumObjectSizeOctets  = 65536
      @maximumKeySizeOctets     =  1024
      @maximumObjectCount       =  1024
      @sessionTimeoutSeconds    =   240
      @receiveTimeoutSeconds    =    60

      @promise = new Promise (resolve, reject) ->
        input = new Buffer
        @stdin
          .on 'data',  (data) => @receive  data
          .on 'end',          => @validate input, resolve, reject
          .on 'error', (err)  => @complain err

    complain: (str) -> @complaints.push str

    receive: (data) -> @input = @input.append data

    validate: (input, resolve, reject) ->
      try
        inputConfig = JSON.parse input

        for k, v of inputConfig
          if not k in @
            @complain new Error "Unknown config key '#{k}'"
          else
            @[k] = v
        @finish config
      catch e
        @complain e

    finish: (config) ->
      if @complaints.length
        reject new Error "There were problems:\n  " + @complaints.join "\n  "
        @help()
      else
        resolve config
