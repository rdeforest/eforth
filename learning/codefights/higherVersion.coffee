_higherVersion = ([a, as...], [b, bs...]) ->
  switch
    when a > b          then true
    when a < b          then false
    when as.length is 0 then false
    else _higherVersion as, bs

module.exports =
  higherVersion = (versions...) ->
    versions = versions
      .map (s) ->
        s .split '.'
          .map (part) -> parseInt part
    _higherVersion versions...
