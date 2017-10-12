module.exports.IWantItAll = (global) ->
  global.qw = (s) -> s.split /\s+/g

  for className in qw 'Array Number String'
    (require "./#{className.toLowerCase()}") global[className]

  Object.assign global,
    (require name for name in qw 'meta bitfield ')...
