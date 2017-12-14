Object.assign exports, require 'rdf/lib/setup-testing'

{
  path: { resolve, dirname, basename },
  fs:   { readdir }
  suite
} = exports

if require.main is module
  suite 'ActiveObject', (suite, test, done) ->
    readdir __dirname, (err, entries) ->
      return done err if err

      entries
        .filter (entry) -> entry.match /^[^.].*coffee$/
        .forEach (entry) ->
          require resolve(__dirname, entry),
            { suite, test, done }

      done()

      
