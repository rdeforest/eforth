Object.assign exports, require 'rdf/lib/setup-testing'

if require.main is module
  {fs} = exports

  fs.readdir __dirname, (err, entries) ->
    
