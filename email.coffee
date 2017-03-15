findEmailDomain = (address) ->
  quoted = false
  escapable = full

  lastAt = address.lastIndexOf '@'
  end = address[lastAt+1..]
  end.replace '"', ''

  return end
