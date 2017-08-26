assert = require 'assert'
fs     = require 'fs'
path   = require 'path'

{ Tracker } = require '../tracker'

module.exports =
  Tracker:
    "should create its data file if none is present": ->
      new Tracker __dirname, 'test.json'

      fs.readFileSync fn = path.resolve __dirname, 'test.json'
      fs.unlinkSync fn

