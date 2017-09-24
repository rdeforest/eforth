path = require 'path'
yaml = require 'js-yaml'

module.exports.Persisted =
class Persisted
  constructor: (@store, @self) ->

module.exports.protocols =
  FileStore:
    class FileStore
      constructor: (cfg) ->
        { @store
        } = cfg

        if not (@store.freeze and @store.melt)
          console.warn "er, um..."

      pathTo: (objOrId) ->
        if ('object' is typeof Id) and id = objOrId.id
          id = actualId
        else
          id = objOrId

        pathTo = path.resolve path, id + '.yaml'

      fetch: (id) ->
        fileName = @pathTo obj
        frozen = yaml.safeLoad fs.readFileSync fileName
        @store.melt frozen

      store: (obj) ->
        fileName = @pathTo obj
        frozen = @store.freeze obj
        fs.writeFileSync fileName, frozen

module.exports.Store =
class Store
  protocol: FileStore

  constructor: (config = {}) ->
    @config = @protocol.processConfig config

