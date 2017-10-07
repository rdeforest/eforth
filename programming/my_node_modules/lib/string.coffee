module.exports = (String) ->
  String.valueIfString = (s) ->
    switch
      when 'string' is typeof s then s
      when s instanceof String then s.valueOf()
