# Packages

- R
- debug
- moment
- joe
- joe-reporter-console
- should
- pug
- coffeescript?
- jquery?

# And now, a pointless exercise

... to find all the package files and count dependencies.

    fs        = require 'fs'
    path      = require 'path'
    process   = require 'process'

    [coffee, script, startDir = '.'] = process.argv

    R         = require 'ramda'

    selector = (e) ->
      if e.startsWith '.'    then return false and console.log "skipping dotfile #{e}"
      if e is 'node_modules' then return false and console.log "skipping #{e}"

      true

    findPackages = (dir) ->
      R.flatten(
        fs.readdirSync(dir)
          .filter selector

          .map (e) ->
            resolved = path.resolve dir, e

            if e is 'package.json'
              "#{dir}": require resolved
            else
              try findPackages resolved

          .filter R.is Object
      )

    found = R.flatten R.map R.values, findPackages startDir

    console.log depends =
      R.sort (([ak, a], [bk, b]) -> a - b),
      R.toPairs R.countBy R.identity, (
        R.flatten (R.flatten (v for k, v of p when k.match /depend/i for p in found)
           .map (o) -> Object.keys o)
        )

