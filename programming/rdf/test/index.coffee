Object.assign module.exports, require '../lib/setup-testing'

{fs, path} = module.exports

module.exports.ourRequire =
ourRequire =
  (name) -> require path.resolve __dirname, '..', 'lib', name

unless module.parent
  otherFile = (name) ->
    name isnt __filename and
    name.endsWith 'coffee'

  fs.readdirSync(__dirname)
    .filter otherFile
    .forEach (name) ->
      console.log "attempting to load '#{name}'"
      ourRequire name

