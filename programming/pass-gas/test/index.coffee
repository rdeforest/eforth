Object.assign module.exports,
  lib: ((name) -> require path.resolve __dirname, '..', 'lib', name)
  require 'rdf/lib/setup-testing',

{fs, path} = module.exports

unless module.parent
  otherFile = (name) ->
    name isnt __filename and
    name.endsWith 'coffee'

  fs.readdirSync(__dirname)
    .filter otherFile
    .forEach (name) ->
      qualified = path.join __dirname, name
      console.log "attempting to load '#{qualified}'"
      require qualified

