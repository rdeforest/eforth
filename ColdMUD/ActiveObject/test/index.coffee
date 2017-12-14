Object.assign exports, require 'rdf/lib/setup-testing'

{ path: { resolve, dirname, basename},
  fs:   { readdir }
} = exports

if require.main is module
  suite '', (suite, test, done) ->
    readdir __dirname, (err, entries) ->
      return done err if err

      entries
        .filter (entry) -> entry.match /^[^.].*coffee$/
        .forEach (entry) ->
          require resolve(__dirname, entry),
            { suite, test, done }

      done()

      
