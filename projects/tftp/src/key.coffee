DEFAULT_TFTP_PORT = 69

# The 'key' is more like a less strict URL. The most important thing is that
# tftp:6969/foo means the host name is 'tftp', but
# tftp:foo/bar means the host name is 'foo'

KEY_PATTERN = ///
  ^
  (?:tftp:(?:\/\/)?)?? # non-greedy match for protocol
  ([^:/]+)             # host name is required
  (?::(\d+))?          # port number is optional
  /(.+)                # At least one character of path is required
  $
///


module.exports =
  class Key
    constructor: (keyString) ->
      if match = keyString.match KEY_PATTERN
        [ wholeString, @host, @port = DEFAULT_TFTP_PORT, @name ] = match
