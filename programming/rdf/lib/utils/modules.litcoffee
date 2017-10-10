    module.exports = (opts) ->
      log = opts.utils.moduleLoadLogger

      unload: ->
        log "\nRestoring globals:"

        for k, v of exports
          log "  %s (%s)", k,
            if k in props prevGlobalValue
              global[k] = prevGlobalValue[k]
              "restored"
            else
              delete global[k]
              "removed"

      reload: (modName = module.filename) ->
        if modName.exports
          mod = modName
          modName = mod.filename
        else
          mod = require.cache[fullName = require.resolve modName]

        if mod
          remove = (mod) ->
            for m in mod.children
              remove m

            if 'function' is typeof mod.exports.unload
              try
                log "Succesfully unloaded #{modName}: %j", unload()
              catch e
                console.warn "Unload of #{modName} failed: %j", e

            delete require.cache[mod.filename]

          remove mod

        mod = require modName

        if opts.utils.reloadReturnsMod
          mod


