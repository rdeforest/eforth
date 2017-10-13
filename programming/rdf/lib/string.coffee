module.exports = (String) ->
  Object.defineProperty String::, 'qw', get: -> @split /\s/g

  String.valueIfString = (s) ->
    switch
      when 'string' is typeof s then s
      when s instanceof String then s.valueOf()
