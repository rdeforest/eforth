    module.exports = (opts) ->
      log = opts.utils.installLogger

      Object.assign {},
        ( for modName, exportName of opts.libs
            if exportName
              try
                mod = require modName

                if 'string' is typeof exportName
                  console.log "adding lib #{modName} as #{exportName}"
                  exports[exportName] = mod
                  undefined
                else
                  console.log "adding lib #{modName}"
                  (m = {})[modName] = mod
                  m
              catch e
                console.log "Error loading '#{modName}': ", e
        ).filter((e) -> e)...
