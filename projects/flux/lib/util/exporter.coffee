module.exports = (modexports, exportables) ->
  unless Array.isArray exportables
    exportables = [exportables]

  for item, idx in exportables
    if not item.name
      throw new Error "Mis-use of exporter: item at index #{idx} has no name"

    modexports[name] = item
