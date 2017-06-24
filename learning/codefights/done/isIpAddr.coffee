isIPv4Address = (inputString) ->
  (octets = inputString.split('.')).length is 4 and
    octets
      .filter (n) -> n.length and 0 <= n <= 255
      .length is 4
