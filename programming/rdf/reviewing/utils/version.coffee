fs = require 'fs'

module.exports.Version =
  class Version
    constructor: (nameOrFile, @major = 0, @minor = 0, @patch = 0) ->
      if arguments.length is 1
        return Version.fromFile nameOrFile

      @name = nameOrFile

    toString: -> "#{@name}-#{[@major, @minor, @patch].join "."}"

    @formatRegex: /^\s*(.*)-(\d+).(\d+).(\d+)\s*$/

    @parse: (s) ->
      if matched = Version.formatRegex.match s
        [all, parts...] = matched
        new Version parts...
      else
        undefined

    @fromFile: (fileName) ->
      v = Version.fromString fs.readFileSync fileName
      v.file = fileName
      v

    save: ->
      if @file
        fs.writeFileSync @file, @toString()

      @

    bump      : ->                       @patch++   ; @save()
    bumpMinor : ->            @minor++ ; @patch = 0 ; @save()
    bumpMajor : -> @major++ ; @minor =   @patch = 0 ; @save()
