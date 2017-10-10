    module.exports = (opts) ->
      log = opts.utils.installLogger

      install: (mod, g = global) ->
        globalVars = Object.getOwnPropertyNames g

        log "\nSetting globals:"

        for k, v of mod?.exports
          mode =
            if k in globalVars
              prevGlobalVal[k] = g[k]
              "(chg)"
            else
              "(new)"

          log "  %s %s", mode, k

          g[k] = v

      setOpts: (o, g = global) ->
        o = o ? opts ? {}
        {repl} = o

        log "\nSetting/updating repl options:"

        for opt, setter of repl
          log "  " + switch
            when 'function' is typeof setter
              "Setter #{opt} returned #{util.inspect setter {opts, global}}"
            when (ref = g.repl?.repl?).hasOwnProperty opt
              "Set repl.repl.#{opt} to #{g.repl.repl[opt] = setter}"
            when (ref = g.module.exports.repl)?.hasOwnProperty opt
              "Set module.exports.repl.#{opt} to #{ref[opt] = setter}"
            else
              "setter not function and repl.repl.#{opt} doesn't exist"

        return
