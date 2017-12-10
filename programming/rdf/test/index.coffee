{fs, path, debug} = Object.assign module.exports, require '../lib/setup-testing'

libDir = path.resolve __dirname, '..', 'lib'
lib = (name) -> require path.resolve libDir, name

Object.assign exports {lib}

otherFile = (name) ->
  name.endsWith 'coffee' and
  name isnt __filename

fs.readdirSync __dirname
  .filter otherFile
  .forEach (name) ->
    qualified = path.join __dirname, name
    console.log "attempting to load '#{qualified}'"
    require qualified

