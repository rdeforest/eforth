module.exports = (stringRearrangement) ->
  expectingTrue = [
    "aa ab bb"
  ].map (s) -> s.split /\s+/

  expectingFalse = [
    "aba bbb bab"
    "q q"
  ].map (s) -> s.split /\s+/

  noExpectation = [
  ].map (s) -> s.split /\s+/

  for l in expectingTrue  when not stringRearrangement l
    console.log "incorrectly false:", l

  for l in expectingFalse when     stringRearrangement l
    console.log "incorrectly true:", l

  for l in noExpectation
    console.log stringRearrangement, '<=', l
