    fs      = require 'fs'
    path    = require 'path'
    version = require 'utils/version'

    modules = {}
    curDir = path.dirname module.filename

    for fileName in fs.readdirSync curDir when not fileName.match 'tags-of-tags'
      [name..., ext] = fileName.split '.'
      name = name.join "."

      if require.extensions["." + ext] and
          not (name in ['index', 'opts', 'version'])
        modules[name] = path.join 'utils', name

    module.exports = exports = (overrides) ->
      Object.assign exports,
        {modules, version}
        enhanceCoreClasses: yes
        utils:
                reloadReturnsMod: false
                install: true
                installLogger: -> # console.log
                moduleLoadLogger: -> # console.log

        repl:
                ignoreUndefined: true

        libs:
                underscore: '__'
                moment: true
                'coffee-script': 'CoffeeScript'

      for k, v of overrides
        Object.assign exports[k], v

      exports
