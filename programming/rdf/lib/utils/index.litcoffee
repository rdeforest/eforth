    Object.assign ?= (target, objs...) ->
      for o in objs
        for k in Object.getOwnPropertyNames o
          target[k] = o[k]

      target

    module.exports = exports =
      opts: opts = (require './opts') {}

    log = opts.utils.installLogger
    Object.assign exports,
      ( for modName, fullPath of opts.modules
          log "loading #{modName}"
          (require fullPath) opts
      )...

    if opts.utils.install
      exports.install module
      exports.setOpts()
      repl.repl.output.write "\nLoaded utils version #{opts.version}\n"
      repl.repl.write '\n'
